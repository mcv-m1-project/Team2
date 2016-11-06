function [SAD_up_triangle, SAD_down_triangle, SAD_square, SAD_circle] = getMinimumSADTrafficSignalTemplates(dirTrain)
%GETMINIMUMSADTRAFFICSIGNALSTEMPLATES
% This function retrieves the minimum values of the SAD (Sum of absolut differences) between a
% signal type and its template in a train set of traffic signal images.
% Paramenters
%   dirTrain --> Path to the training set
% Returns
%   SAD_up_triangle: array with minimum and maximum SAD values for the up triangle signals
%   SAD_down_triangle: array with minimum and maximum SAD values for the down triangle signals
%   SAD_circle: array with minimum and maximum SAD values for the circle signals
%   SAD_square: array with minimum and maximum SAD values for the square signals

    files = ListFiles(dirTrain);
    nFiles = length(files);
    
    load('grayModels.mat');   
    
    circleCount = 0;
    squareCount = 0;
    upTriangleCount = 0;
    downTriangleCount = 0;
        
    SAD_up_triangle = [];
    SAD_down_triangle = [];
    SAD_square = [];
    SAD_circle = [];
    
    for i=1:nFiles
        im = imread([dirTrain, '\', files(i).name]);
        gt = [dirTrain, '\gt\gt.',strrep(files(i).name, '.jpg', '.txt')];
        [annotations signs] = LoadAnnotations(gt);
        for j=1:length(signs)
            im_windowed = imcrop(im,[annotations(j).x,annotations(j).y,annotations(j).w-1,annotations(j).h-1]);
            
            
            switch signs{j}
                case 'A'
                    upTriangleCount = upTriangleCount +1;
                    im_windowed_gray = rgb2gray(im_windowed);
                    template_gray = imresize(upTriangleTemp_gray,size(im_windowed_gray));
                    SAD = computeSAD(im_windowed_gray,template_gray);
                    SAD_up_triangle(upTriangleCount) = SAD;
                case 'B'
                    downTriangleCount = downTriangleCount +1;
                    im_windowed_gray = rgb2gray(im_windowed);
                    template_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                    SAD = computeSAD(im_windowed_gray,template_gray);
                    SAD_down_triangle(downTriangleCount) = SAD;
                case 'F'
                    squareCount = squareCount +1;
                    im_windowed_gray = rgb2gray(im_windowed);
                    template_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                    SAD = computeSAD(im_windowed_gray,template_gray);
                    SAD_square(squareCount) = SAD;
                otherwise
                    circleCount = circleCount +1;
                    im_windowed_gray = rgb2gray(im_windowed);
                    template_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                    SAD = computeSAD(im_windowed_gray,template_gray);
                    SAD_circle(circleCount) = SAD;
            end
        end
    end
    SAD_up_triangle = [min(SAD_up_triangle),max((SAD_up_triangle))];
    SAD_down_triangle = [min(SAD_down_triangle),max(SAD_down_triangle)];
    SAD_square = [min(SAD_square),max(SAD_square)];
    SAD_circle = [min(SAD_circle),max(SAD_circle)];
end

function SAD = computeSAD(im, model)
[imN,imM] = size(im);
[modelN,modelM] = size(model);
SAD = 0;
for j = 1:modelM
    for i = 1:modelN
        p_Im = double(im(i,j));
        p_Template = double(model(i,j));
        
        SAD = SAD + abs( p_Im - p_Template );
    end
end
end