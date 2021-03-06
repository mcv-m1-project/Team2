function [mask, windowCandidates] = templateMatchingSweep( im, models, system, th )
%TEMPLATEMATCHING Summary of this function goes here
%   Detailed explanation goes here
    maskUpTriangle = sweepModel(im,models.upTriangleTemp_gray,system, th);
    maskDownTriangle = sweepModel(im,models.downTriangleTemp_gray,system, th);
    maskSquare = sweepModel(im,models.squareTemp_gray,system, th);
    maskCircle = sweepModel(im,models.circleTemp_gray,system, th);

    mask = maskUpTriangle + maskDownTriangle + maskSquare + maskCircle;
    mask(mask > 0) = 1;
    
    CC = bwconncomp(mask);
    CCproperties = regionprops(CC, 'BoundingBox');
    windowCandidates = [];
    for j = 1:CC.NumObjects
        x = floor(CCproperties(j).BoundingBox(1));
        y = floor(CCproperties(j).BoundingBox(2));
        w = CCproperties(j).BoundingBox(3);
        h = CCproperties(j).BoundingBox(4);
        
        windowCandidates = [windowCandidates; struct('x', x, 'y', y, 'w',w,'h',h);];
    end
end

function mask = sweepModel(im, model, system, th)
[imN,imM,~] = size(im);
mask = zeros(imN,imM);
while size(model,1)*size(model,2) > 915
    [modelN,modelM,~] = size(model);
    subMask = zeros(modelN, modelM,3);
    subMask(model>0) = 1;
    switch system
        case 'substraction'
            minSAD = th;
            % loop through the search image
            for x = 1:round(modelN*0.1):(imN - modelN)
                for y = 1:round(modelN*0.1):(imM - modelM)
                    SAD = 0;
                    % loop through the template image
                    for j = 1:modelM
                        for i = 1:modelN
                            p_Im = double(im(x+i,y+j));
                            p_Template = double(model(i,j));
                            
                            SAD = SAD + abs( p_Im - p_Template );
                        end
                    end
                    % save the best found position
                    if ( minSAD > SAD )
                        minSAD = SAD;
                        % give me min SAD
                        bestRow = x;
                        bestCol = y;
                    end
                end
            end
            mask(bestRow:min(imN,bestRow+modelN-1),bestCol:min(imM,bestCol+modelM-1)) = subMask(:,:,1);
        case 'correlation'
            R = normxcorr2(model,rgb2gray(im));
            if max(max(R)) > th
                [rowsMax, colsMax] = find(R == max(max(R)));
                rowsMax = rowsMax - modelN + 1;
                colsMax = colsMax - modelM + 1;
                for i=1:length(rowsMax)
                    rowsIm = max(1,rowsMax):min(rowsMax+modelN-1,imN);
                    colsIm = max(1,colsMax):min(colsMax+modelM-1,imM);
                    if length(rowsIm) < modelN
                        if rowsIm(1) == 1
                            rowsModel = modelN-length(rowsIm)+1:modelN;
                        else
                            rowsModel = 1:length(rowsIm);
                        end
                    else
                        rowsModel = 1:modelN;
                    end
                    if length(colsIm) < modelM
                       if colsIm(1) == 1
                           colsModel = modelM-length(colsIm)+1:modelM;
                       else
                           colsModel = 1:length(colsIm);
                       end 
                    else
                        colsModel = 1:modelM;
                    end
                    mask(rowsIm,colsIm) = subMask(rowsModel,colsModel);
                end
            end
        otherwise
            error('Invalid method, valid ones ara substraction and correlation');
    end
    model = imresize(model,0.7);
end
mask(mask>0) = 1;
end