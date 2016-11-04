function mask = templateMatchingSweep( im, models, system, th )
%TEMPLATEMATCHING Summary of this function goes here
%   Detailed explanation goes here
    maskUpTriangle = sweepModel(im,models.upTriangleTemp,system, th);
    maskDownTriangle = sweepModel(im,models.downTriangleTemp,system, th);
    maskSquare = sweepModel(im,models.squareTemp,system, th);
    maskCircle = sweepModel(im,models.circleTemp,system, th);

    mask = maskUpTriangle + maskDownTriangle + maskSquare + maskCircle;
    mask(mask > 0) = 1;
end

function mask = sweepModel(im, model, system, th)
[imN,imM,~] = size(im);
mask = zeros(imN,imM);
while size(model,1)*size(model,2) > 915
    model = imresize(model,0.7);
    [modelN,modelM,~] = size(model);
    subMask = zeros(modelN, modelM,3);
    subMask(model>0) = 1;
    switch system
        case 'susbtraction'
            for n=1:round(modelN*0.1):imN-modelN
                for m=1:round(modelM*0.1):imM-modelM
                    subIm = im(n:min(imN,n+modelN-1),m:min(imM,m+modelM-1),:);
                    
                    dif = abs(subIm - model);
                    if sum(sum(sum(dif))) < th
                        mask(n:min(imN,n+modelN-1),m:min(imM,m+modelM-1)) = subMask;
                    end
                    
                end
            end
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
end
mask(mask>0) = 1;
end