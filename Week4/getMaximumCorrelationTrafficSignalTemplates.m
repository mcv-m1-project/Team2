function [max_corr_up_triangle_gray, max_corr_down_triangle_gray, max_corr_square_gray, max_corr_circle_gray] = getMaximumCorrelationTrafficSignalTemplates(dirTrain)
%GETMAXIMUMCORRELATIONTRAFFICSIGNALSTEMPLATES
% This function retrieves the maximum values of the correlation between a
% signal type and its template in a train set of traffic signal images.
% Paramenters
%   dirTrain --> Path to the training set
% Returns
%   max_corr_up_triangle_gray: array with the max correlation values
%   for the up triangle signals
%   max_corr_down_triangle_gray: array with the max correlation values
%   for the down triangle signals
%   max_corr_circle_gray: array with the max correlation values
%   for the circle signals
%   max_corr_square_gray: array with the max correlation values
%   for the square signals

    files = ListFiles(dirTrain);
    nFiles = length(files);
    
    load('grayModels.mat');   
    
    circleCount = 0;
    squareCount = 0;
    upTriangleCount = 0;
    downTriangleCount = 0;
        
    max_corr_up_triangle_gray = [];
    max_corr_down_triangle_gray = [];
    max_corr_square_gray = [];
    max_corr_circle_gray = [];
    
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
                    corr = normxcorr2(template_gray,im_windowed_gray);
                    [ypeak, xpeak] = find(corr==max(corr(:)));
                    max_corr_up_triangle_gray(upTriangleCount) = corr(ypeak, xpeak);
                case 'B'
                    downTriangleCount = downTriangleCount +1;
                    im_windowed_gray = rgb2gray(im_windowed);
                    template_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                    corr = normxcorr2(template_gray,im_windowed_gray);
                    [ypeak, xpeak] = find(corr==max(corr(:)));
                    max_corr_down_triangle_gray(downTriangleCount) = corr(ypeak, xpeak);
                case 'F'
                    squareCount = squareCount +1;
                    im_windowed_gray = rgb2gray(im_windowed);
                    template_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                    corr = normxcorr2(template_gray,im_windowed_gray);
                    [ypeak, xpeak] = find(corr==max(corr(:)));
                    max_corr_square_gray(squareCount) = corr(ypeak, xpeak);
                otherwise
                    circleCount = circleCount +1;
                    im_windowed_gray = rgb2gray(im_windowed);
                    template_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                    corr = normxcorr2(template_gray,im_windowed_gray);
                    [ypeak, xpeak] = find(corr==max(corr(:)));
                    max_corr_circle_gray(circleCount) = corr(ypeak, xpeak);
            end
        end
    end
end