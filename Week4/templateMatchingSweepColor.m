function [mask, windowCandidates] = templateMatchingSweepColor( im, models, system, th )
%TEMPLATEMATCHINGCOLOR Summary of this function goes here
%   Detailed explanation goes here
    im = rgb2hsv(im);
    masks = load('maskModels');
    maskUpTriangle = sweepModel(im,models.upTriangleTemp_color,masks.upTriangleTemp_mask,system, th);
    maskDownTriangle = sweepModel(im,models.downTriangleTemp_color,masks.downTriangleTemp_mask,system, th);
    maskSquare = sweepModel(im,models.squareTemp_color,masks.squareTemp_mask,system, th);
    maskCircle = sweepModel(im,models.circleTemp_color,masks.circleTemp_mask,system, th);

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

function mask = sweepModel(im, model, subMask, system, th)
[imN,imM,~] = size(im);
mask = zeros(imN,imM);
model = rgb2hsv(model);
while size(model,1)*size(model,2) > 915
    [modelN,modelM,~] = size(model);
    switch system
        case 'susbtraction'
            minSAD = th;
            % loop through the search image
            for x = 1:(imN - modelN)
                for y = 1:(imM - modelM)
                    SAD = 0;
                    % loop through the template image
                    for j = 1:modelM
                        for i = 1:modelN
                            p_Im_H = im(x+i,y+j,1);
                            p_Template_H = model(i,j,1);
                            
                            p_Im_S = im(x+i,y+j,2);
                            p_Template_S = model(i,j,2);
                            
                            SAD = SAD + abs( p_Im_H - p_Template_H ) + abs( p_Im_S - p_Template_S );
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
            end
            mask(bestRow:min(imN,bestRow+modelN-1),bestCol:min(imM,bestCol+modelM-1)) = subMask;
        case 'correlation'
            RH = normxcorr2(model(:,:,1),im(:,:,1));
            RS = normxcorr2(model(:,:,2),im(:,:,2));
            R = (RH + RS) / 2;
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
    [modelN,modelM,~] = size(model);
    subMask = imresize(model,[modelN,modelM]);
end
mask(mask>0) = 1;
end