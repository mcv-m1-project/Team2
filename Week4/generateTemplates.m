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
%   formFactor --> vector with the mean form factor of each traffic signal
%   type (to determine the models form factor)

    addpath('..')
    addpath('..\evaluation')
    files = ListFiles(dirTrain);
    nFiles = length(files);
    
    maxSizeCircle = max([maxSize(3),maxSize(4),maxSize(5)]);
    meanFfCircle = mean([formFactor(3),formFactor(4),formFactor(5)]);
    % [Height Width] 
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
            imMasked = double(imcrop(im.*mask,[annotations(j).x,annotations(j).y,annotations(j).w - 1,annotations(j).h - 1]));
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
    upTriangleTemp_color = uint8(round(upTriangleTemp/upTriangleCount));
    downTriangleTemp_color = uint8(round(downTriangleTemp/downTriangleCount));
    squareTemp_color = uint8(round(squareTemp/squareCount));
    circleTemp_color = uint8(round(circleTemp/circleCount));
    save('colorModels','upTriangleTemp_color','downTriangleTemp_color','squareTemp_color','circleTemp_color');
    
    figure,
    subplot(4,4,1),imshow(upTriangleTemp_color)
    subplot(4,4,2),imshow(downTriangleTemp_color)
    subplot(4,4,3),imshow(squareTemp_color)
    subplot(4,4,4),imshow(circleTemp_color)
    
    upTriangleTemp_gray = rgb2gray(upTriangleTemp_color);
    downTriangleTemp_gray = rgb2gray(downTriangleTemp_color);
    squareTemp_gray = rgb2gray(squareTemp_color);
    circleTemp_gray = rgb2gray(circleTemp_color);
    save('grayModels','upTriangleTemp_gray','downTriangleTemp_gray','squareTemp_gray','circleTemp_gray');

    subplot(4,4,5),imshow(upTriangleTemp_gray)
    subplot(4,4,6),imshow(downTriangleTemp_gray)
    subplot(4,4,7),imshow(squareTemp_gray)
    subplot(4,4,8),imshow(circleTemp_gray)
    
    upTriangleEdges = edge(upTriangleTemp_gray,'canny');
    downTriangleEdges = edge(downTriangleTemp_gray,'canny');
    squareEdges = edge(squareTemp_gray,'canny');
    circleEdges = edge(circleTemp_gray,'canny');
    save('edgesModels','upTriangleEdges','downTriangleEdges','squareEdges','circleEdges');

    subplot(4,4,13),imshow(upTriangleEdges,[0 1])
    subplot(4,4,14),imshow(downTriangleEdges,[0 1])
    subplot(4,4,15),imshow(squareEdges,[0 1])
    subplot(4,4,16),imshow(circleEdges,[0 1])
    
    upTriangleTemp_gray(upTriangleTemp_gray > 0) = 1;
    upTriangleTemp_mask = upTriangleTemp_gray;
    downTriangleTemp_gray(downTriangleTemp_gray > 0) = 1;
    downTriangleTemp_mask = downTriangleTemp_gray;
    squareTemp_gray(squareTemp_gray > 0) = 1;
    squareTemp_mask = squareTemp_gray;
    circleTemp_gray(circleTemp_gray > 0) = 1;
    circleTemp_mask = circleTemp_gray;
    save('maskModels','upTriangleTemp_mask','downTriangleTemp_mask','squareTemp_mask','circleTemp_mask');
    
    subplot(4,4,9),imshow(upTriangleTemp_mask,[0 1])
    subplot(4,4,10),imshow(downTriangleTemp_mask,[0 1])
    subplot(4,4,11),imshow(squareTemp_mask,[0 1])
    subplot(4,4,12),imshow(circleTemp_mask,[0 1])
    

end

