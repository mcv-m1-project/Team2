function [max_corr_up_triangle_hs, max_corr_down_triangle_hs, max_corr_square_hs, max_corr_circle_C_hs, max_corr_circle_D_hs, max_corr_circle_E_hs] = getMaximumCorrelationTrafficSignalTemplates_HSV(dirTrain)
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
    
    %load('grayModels.mat'); 
    load('hsvModels_6types.mat');
    
    
    downTriangleTemp_h = downTriangleTemp_hsv(:,:,1);
    downTriangleTemp_h = downTriangleTemp_h./sqrt(sum(downTriangleTemp_h(:).^2));    
    downTriangleTemp_s = downTriangleTemp_hsv(:,:,2);
    downTriangleTemp_s = downTriangleTemp_s./sqrt(sum(downTriangleTemp_s(:).^2)); 
    upTriangleTemp_h = upTriangleTemp_hsv(:,:,1);
    upTriangleTemp_h = upTriangleTemp_h./sqrt(sum(upTriangleTemp_h(:).^2));
    upTriangleTemp_s = upTriangleTemp_hsv(:,:,2);
    upTriangleTemp_s = upTriangleTemp_s./sqrt(sum(upTriangleTemp_s(:).^2));      
    squareTemp_h = squareTemp_hsv(:,:,1);
    squareTemp_h = squareTemp_h./sqrt(sum(squareTemp_h(:).^2));
    squareTemp_s = squareTemp_hsv(:,:,2);
    squareTemp_s = squareTemp_s./sqrt(sum(squareTemp_s(:).^2));
    circleTemp_C_h = circleTemp_C_hsv(:,:,1);
    circleTemp_C_h = circleTemp_C_h./sqrt(sum(circleTemp_C_h(:).^2));
    circleTemp_C_s = circleTemp_C_hsv(:,:,2); 
    circleTemp_C_s = circleTemp_C_s./sqrt(sum(circleTemp_C_s(:).^2));
    circleTemp_D_h = circleTemp_D_hsv(:,:,1);
    circleTemp_D_h = circleTemp_D_h./sqrt(sum(circleTemp_D_h(:).^2));
    circleTemp_D_s = circleTemp_D_hsv(:,:,2);
    circleTemp_D_s = circleTemp_D_s./sqrt(sum(circleTemp_D_s(:).^2));
    circleTemp_E_h = circleTemp_E_hsv(:,:,1);
    circleTemp_E_h = circleTemp_E_h./sqrt(sum(circleTemp_E_h(:).^2));
    circleTemp_E_s = circleTemp_E_hsv(:,:,2);
    circleTemp_E_s = circleTemp_E_s./sqrt(sum(circleTemp_E_s(:).^2));
    
    circleCount_C = 0;
    circleCount_D = 0;
    circleCount_E = 0;
    squareCount = 0;
    upTriangleCount = 0;
    downTriangleCount = 0;
    
    max_corr_up_triangle_hs = [];
    max_corr_down_triangle_hs = [];
    max_corr_square_hs = [];
    max_corr_circle_C_hs = [];
    max_corr_circle_D_hs = [];
    max_corr_circle_E_hs = [];
    
    figure,
    for i=1:nFiles
        im = imread([dirTrain, '\', files(i).name]);
        gt = [dirTrain, '\gt\gt.',strrep(files(i).name, '.jpg', '.txt')];
        [annotations signs] = LoadAnnotations(gt);
        for j=1:length(signs)
            im_windowed = imcrop(im,[annotations(j).x,annotations(j).y,annotations(j).w-1,annotations(j).h-1]);
            im_windowed_hsv = rgb2hsv(im_windowed);
            im_windowed_h = im_windowed_hsv(:,:,1);
            im_windowed_s = im_windowed_hsv(:,:,2); 
            im_windowed_h = im_windowed_h./sqrt(sum(im_windowed_h(:).^2));
            im_windowed_s = im_windowed_s./sqrt(sum(im_windowed_s(:).^2));
            
            switch signs{j}
                case 'A'
                    upTriangleCount = upTriangleCount +1;
                    template_h = imresize(upTriangleTemp_h,size(im_windowed_hsv(:,:,1)));
                    corr_h = normxcorr2(template_h,im_windowed_h);
                    [ypeak_h, xpeak_h] = find(abs(corr_h)==max(abs(corr_h(:)))); 
                    template_s = imresize(upTriangleTemp_s,size(im_windowed_hsv(:,:,2)));
                     corr_s = normxcorr2(template_s,im_windowed_s);
                    [ypeak_s, xpeak_s] = find(abs(corr_s)==max(abs(corr_s(:))));
                    max_corr_up_triangle_hs = [max_corr_up_triangle_hs [abs(corr_h(ypeak_h, xpeak_h)); abs(corr_s(ypeak_s, xpeak_s))]];
                case 'B'
                    downTriangleCount = downTriangleCount +1;
                    template_h = imresize(downTriangleTemp_h,size(im_windowed_hsv(:,:,1)));
                    corr_h = normxcorr2(template_h,im_windowed_h);
                    [ypeak_h, xpeak_h] = find(abs(corr_h)==max(abs(corr_h(:)))); 
                    template_s = imresize(downTriangleTemp_s,size(im_windowed_hsv(:,:,2)));
                     corr_s = normxcorr2(template_s,im_windowed_s);
                    [ypeak_s, xpeak_s] = find(abs(corr_s)==max(abs(corr_s(:))));
                    max_corr_down_triangle_hs = [max_corr_down_triangle_hs [abs(corr_h(ypeak_h, xpeak_h)); abs(corr_s(ypeak_s, xpeak_s))]];
                case 'C'
                    circleCount_C = circleCount_C +1;
                    template_h = imresize(circleTemp_C_h,size(im_windowed_hsv(:,:,1)));
                    corr_h = normxcorr2(template_h,im_windowed_h);
                    [ypeak_h, xpeak_h] = find(abs(corr_h)==max(abs(corr_h(:)))); 
                    template_s = imresize(circleTemp_C_s,size(im_windowed_hsv(:,:,2)));
                     corr_s = normxcorr2(template_s,im_windowed_s);
                    [ypeak_s, xpeak_s] = find(abs(corr_s)==max(abs(corr_s(:))));
                    max_corr_circle_C_hs = [max_corr_circle_C_hs [abs(corr_h(ypeak_h, xpeak_h)); abs(corr_s(ypeak_s, xpeak_s))]];           
                case 'D'
                    circleCount_D = circleCount_D +1;
                    template_h = imresize(circleTemp_D_h,size(im_windowed_hsv(:,:,1)));
                    corr_h = normxcorr2(template_h,im_windowed_h);
                    [ypeak_h, xpeak_h] = find(abs(corr_h)==max(abs(corr_h(:))));
                    template_s = imresize(circleTemp_D_s,size(im_windowed_hsv(:,:,2)));
                     corr_s = normxcorr2(template_s,im_windowed_s);
                    [ypeak_s, xpeak_s] = find(abs(corr_s)==max(abs(corr_s(:))));
                    max_corr_circle_D_hs = [max_corr_circle_D_hs [abs(corr_h(ypeak_h, xpeak_h)); abs(corr_s(ypeak_s, xpeak_s))]];
                case 'E'
                    circleCount_E = circleCount_E +1;
                    template_h = imresize(circleTemp_E_h,size(im_windowed_hsv(:,:,1)));
                    corr_h = normxcorr2(template_h,im_windowed_h);
                    [ypeak_h, xpeak_h] = find(abs(corr_h)==max(abs(corr_h(:))));
                    template_s = imresize(circleTemp_E_s,size(im_windowed_hsv(:,:,2)));
                    corr_s = normxcorr2(template_s,im_windowed_s);
                    [ypeak_s, xpeak_s] = find(abs(corr_s)==max(abs(corr_s(:))));
                    max_corr_circle_E_hs = [max_corr_circle_E_hs [abs(corr_h(ypeak_h, xpeak_h)); abs(corr_s(ypeak_s, xpeak_s))]];
                case 'F'
                    squareCount = squareCount +1;
                    template_h = imresize(squareTemp_h,size(im_windowed_hsv(:,:,1)));
                    corr_h = normxcorr2(template_h,im_windowed_h);
                    [ypeak_h, xpeak_h] = find(abs(corr_h)==max(abs(corr_h(:)))); 
                    template_s = imresize(squareTemp_s,size(im_windowed_hsv(:,:,2)));
                     corr_s = normxcorr2(template_s,im_windowed_s);
                    [ypeak_s, xpeak_s] = find(abs(corr_s)==max(abs(corr_s(:))));
                    max_corr_square_hs = [max_corr_square_hs [abs(corr_h(ypeak_h, xpeak_h)); abs(corr_s(ypeak_s, xpeak_s))]];      
                otherwise
            end
        end
    end
end