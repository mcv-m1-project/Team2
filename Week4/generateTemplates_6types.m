function generateTemplates_6types( dirTrain, maxSize, formFactor )
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
    
    % [Height Width] 
    circleSize_C = [round(sqrt(maxSize(3)/formFactor(3))), round(sqrt(maxSize(3)*formFactor(3)))];
    circleTemp_C = zeros([circleSize_C,3]);
    circleCount_C = 0;
    
    circleSize_D = [round(sqrt(maxSize(4)/formFactor(4))), round(sqrt(maxSize(4)*formFactor(4)))];
    circleTemp_D = zeros([circleSize_D,3]);
    circleCount_D = 0;
    
    circleSize_E = [round(sqrt(maxSize(5)/formFactor(5))), round(sqrt(maxSize(5)*formFactor(5)))];
    circleTemp_E = zeros([circleSize_E,3]);
    circleCount_E = 0;
    
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
                case 'C'
                    imMasked = imresize(imMasked,circleSize_C);
                    circleTemp_C = circleTemp_C + imMasked;
                    circleCount_C = circleCount_C + 1;
                case 'D'
                    imMasked = imresize(imMasked,circleSize_D);
                    circleTemp_D = circleTemp_D + imMasked;
                    circleCount_D = circleCount_D + 1;
                case 'E'
                    imMasked = imresize(imMasked,circleSize_E);
                    circleTemp_E = circleTemp_E + imMasked;
                    circleCount_E = circleCount_E + 1;
                otherwise
            end
        end
    end
    
    
    upTriangleTemp_color = uint8(round(upTriangleTemp/upTriangleCount));
    downTriangleTemp_color = uint8(round(downTriangleTemp/downTriangleCount));
    squareTemp_color = uint8(round(squareTemp/squareCount));
    circleTemp_C_color = uint8(round(circleTemp_C/circleCount_C));
    circleTemp_D_color = uint8(round(circleTemp_D/circleCount_D));
    circleTemp_E_color = uint8(round(circleTemp_E/circleCount_E));
    save('colorModels_6types','upTriangleTemp_color','downTriangleTemp_color','squareTemp_color','circleTemp_C_color','circleTemp_D_color', 'circleTemp_E_color');
    
    figure,
    subplot(4,6,1),imshow(upTriangleTemp_color)
    subplot(4,6,2),imshow(downTriangleTemp_color)
    subplot(4,6,3),imshow(squareTemp_color)
    subplot(4,6,4),imshow(circleTemp_C_color)
    subplot(4,6,5),imshow(circleTemp_D_color)
    subplot(4,6,6),imshow(circleTemp_E_color)
    
    upTriangleTemp_gray = rgb2gray(upTriangleTemp_color);
    downTriangleTemp_gray = rgb2gray(downTriangleTemp_color);
    squareTemp_gray = rgb2gray(squareTemp_color);
    circleTemp_C_gray = rgb2gray(circleTemp_C_color);
    circleTemp_D_gray = rgb2gray(circleTemp_D_color);
    circleTemp_E_gray = rgb2gray(circleTemp_E_color);
    save('grayModels_6types','upTriangleTemp_gray','downTriangleTemp_gray','squareTemp_gray','circleTemp_C_gray','circleTemp_D_gray', 'circleTemp_E_gray');

    subplot(4,6,7),imshow(upTriangleTemp_gray)
    subplot(4,6,8),imshow(downTriangleTemp_gray)
    subplot(4,6,9),imshow(squareTemp_gray)
    subplot(4,6,10),imshow(circleTemp_C_gray)
    subplot(4,6,11),imshow(circleTemp_D_gray)
    subplot(4,6,12),imshow(circleTemp_E_gray)
    
    upTriangleTemp_hsv = rgb2hsv(upTriangleTemp_color);
    downTriangleTemp_hsv = rgb2hsv(downTriangleTemp_color);
    squareTemp_hsv = rgb2hsv(squareTemp_color);
    circleTemp_C_hsv = rgb2hsv(circleTemp_C_color);
    circleTemp_D_hsv = rgb2hsv(circleTemp_D_color);
    circleTemp_E_hsv = rgb2hsv(circleTemp_E_color);
    save('hsvModels_6types','upTriangleTemp_hsv','downTriangleTemp_hsv','squareTemp_hsv','circleTemp_C_hsv', 'circleTemp_D_hsv', 'circleTemp_E_hsv');

    subplot(4,6,13),imshow(upTriangleTemp_hsv)
    subplot(4,6,14),imshow(downTriangleTemp_hsv)
    subplot(4,6,15),imshow(squareTemp_hsv)
    subplot(4,6,16),imshow(circleTemp_C_hsv)
    subplot(4,6,17),imshow(circleTemp_D_hsv)
    subplot(4,6,18),imshow(circleTemp_E_hsv)
    
    upTriangleTemp_gray(upTriangleTemp_gray > 0) = 1;
    upTriangleTemp_mask = upTriangleTemp_gray;
    downTriangleTemp_gray(downTriangleTemp_gray > 0) = 1;
    downTriangleTemp_mask = downTriangleTemp_gray;
    squareTemp_gray(squareTemp_gray > 0) = 1;
    squareTemp_mask = squareTemp_gray;
    circleTemp_C_gray(circleTemp_C_gray > 0) = 1;
    circleTemp_C_mask = circleTemp_C_gray;
    circleTemp_D_gray(circleTemp_D_gray > 0) = 1;
    circleTemp_D_mask = circleTemp_D_gray;
    circleTemp_E_gray(circleTemp_E_gray > 0) = 1;
    circleTemp_E_mask = circleTemp_E_gray;
    save('maskModels_6types','upTriangleTemp_mask','downTriangleTemp_mask','squareTemp_mask','circleTemp_C_mask','circleTemp_D_mask', 'circleTemp_E_mask');
    
    subplot(4,6,19),imshow(upTriangleTemp_mask,[0 1])
    subplot(4,6,20),imshow(downTriangleTemp_mask,[0 1])
    subplot(4,6,21),imshow(squareTemp_mask,[0 1])
    subplot(4,6,22),imshow(circleTemp_C_mask,[0 1])
    subplot(4,6,23),imshow(circleTemp_D_mask,[0 1])
    subplot(4,6,24),imshow(circleTemp_E_mask,[0 1])

end

