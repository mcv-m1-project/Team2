function generateTemplates( dirTrain, maxSize, formFactor )
%GENERATETEMPLATES
% This function generates four models for each shape of traffic signal
%   Color models --> traffic signal model in color space
%   Gray models --> traffic signal model in gray-level scale
%   Mask models --> traffic signal model in mask terms
%   Edges models --> traffic signal edges model
% For each model type it generates a circle model, a square model, a up
% triangle model and a down traingle model
% 
% Paramenters
%   dirTrain --> Path to the training set
%   maxSize --> vector with the max size of each traffic signal type (to
%   determine the models size)
%   formFactor --> vector withe the mean form factor of each traffic signal
%   type (to determine the models form factor)

    addpath('..')
    addpath('..\evaluation')
    files = ListFiles(dirTrain);
    nFiles = length(files);
    
    maxSizeCircle = max([maxSize(3),maxSize(4),maxSize(5)]);
    meanFfCircle = mean([formFactor(3),formFactor(4),formFactor(5)]);
    circleSize = [round(sqrt(maxSizeCircle/meanFfCircle)), round(sqrt(maxSizeCircle*meanFfCircle))];
    circleTemp = zeros([circleSize,3]);
    circleCount = 0;
    squareSize = [round(sqrt(maxSize(6)/formFactor(6))), round(sqrt(maxSize(6)*formFactor(6)))];
    squareTemp = zeros([squareSize,3]);
    squareCount = 0;
    upTriangleSize = [round(sqrt(maxSize(1)/formFactor(1))), round(sqrt(maxSize(1)*formFactor(1)))];
    upTriangleTemp = zeros([upTriangleSize,3]);
    upTriangleCount = 0;
    downTriangleSize = [round(sqrt(maxSize(2)/formFactor(2))), round(sqrt(maxSize(2)*formFactor(2)))];
    downTriangleTemp = zeros([downTriangleSize,3]);
    downTriangleCount = 0;
    
    for i=1:nFiles
        im = imread([dirTrain, '\', files(i).name]);
        mask = imread([dirTrain, '\mask\mask.',strrep(files(i).name, '.jpg', '.png')]);
        gt = [dirTrain, '\gt\gt.',strrep(files(i).name, '.jpg', '.txt')];
        [annotations signs] = LoadAnnotations(gt);
        for j=1:length(signs)
            imMasked = double(imcrop(im.*mask,[annotations(j).x,annotations(j).y,annotations(j).w,annotations(j).h]));
            switch signs{j}
                case 'A'
                    imMasked = imresize(imMasked,upTriangleSize);
                    upTriangleTemp = upTriangleTemp + imMasked;
                    upTriangleCount = upTriangleCount+ 1;
                case 'B'
                    imMasked = imresize(imMasked,downTriangleSize);
                    downTriangleTemp = downTriangleTemp + imMasked;
                    downTriangleCount = downTriangleCount+ 1;
                case 'F'
                    imMasked = imresize(imMasked,squareSize);
                    squareTemp = squareTemp + imMasked;
                    squareCount = squareCount+ 1;
                otherwise
                    imMasked = imresize(imMasked,circleSize);
                    circleTemp = circleTemp + imMasked;
                    circleCount = circleCount+ 1;
            end
        end
    end
    upTriangleTemp = uint8(round(upTriangleTemp/upTriangleCount));
    downTriangleTemp = uint8(round(downTriangleTemp/downTriangleCount));
    squareTemp = uint8(round(squareTemp/squareCount));
    circleTemp = uint8(round(circleTemp/circleCount));
    save('colorModels','upTriangleTemp','downTriangleTemp','squareTemp','circleTemp');
    
    figure,
    subplot(4,4,1),imshow(upTriangleTemp)
    subplot(4,4,2),imshow(downTriangleTemp)
    subplot(4,4,3),imshow(squareTemp)
    subplot(4,4,4),imshow(circleTemp)
    
    upTriangleTemp = rgb2gray(upTriangleTemp);
    downTriangleTemp = rgb2gray(downTriangleTemp);
    squareTemp = rgb2gray(squareTemp);
    circleTemp = rgb2gray(circleTemp);
    save('grayModels','upTriangleTemp','downTriangleTemp','squareTemp','circleTemp');

    subplot(4,4,5),imshow(upTriangleTemp)
    subplot(4,4,6),imshow(downTriangleTemp)
    subplot(4,4,7),imshow(squareTemp)
    subplot(4,4,8),imshow(circleTemp)
    
    upTriangleEdges = edge(upTriangleTemp,'canny');
    downTriangleEdges = edge(downTriangleTemp,'canny');
    squareEdges = edge(squareTemp,'canny');
    circleEdges = edge(circleTemp,'canny');
    save('edgesModels','upTriangleEdges','downTriangleEdges','squareEdges','circleEdges');

    subplot(4,4,13),imshow(upTriangleEdges,[0 1])
    subplot(4,4,14),imshow(downTriangleEdges,[0 1])
    subplot(4,4,15),imshow(squareEdges,[0 1])
    subplot(4,4,16),imshow(circleEdges,[0 1])
    
    upTriangleTemp(upTriangleTemp > 0) = 1;
    downTriangleTemp(downTriangleTemp > 0) = 1;
    squareTemp(squareTemp > 0) = 1;
    circleTemp(circleTemp > 0) = 1;
    save('maskModels','upTriangleTemp','downTriangleTemp','squareTemp','circleTemp');
    
    subplot(4,4,9),imshow(upTriangleTemp,[0 1])
    subplot(4,4,10),imshow(downTriangleTemp,[0 1])
    subplot(4,4,11),imshow(squareTemp,[0 1])
    subplot(4,4,12),imshow(circleTemp,[0 1])
    

end

