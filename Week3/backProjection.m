function [time] = backProjection(data_set)
% Performs the back-projection algorithm to find the masks.
% The algorithm saves the resulting masks inside the folder
% '/result_masks/color_segmentation' that crates inside the data_set path
% Also returns the time per frame required.
    %    Parameter name      Value
    %    --------------      -----
    %     data_set           Path to the data_set
    tic
    
    files = listFiles(data_set);
    nFiles = size(files, 1);
    
    th_eval = 0.004;
    sat_radiuses = 0.5;
    bins = 32;

    load(['red_hist_' num2str(bins) '.mat'])
    load(['blue_hist_' num2str(bins) '.mat'])
    load(['rb_hist_' num2str(bins) '.mat'])

    red_hist(:,1:round(bins * sat_radiuses)) = 0;
    blue_hist(:,1:round(bins * sat_radiuses)) = 0;
    rb_hist(:,1:round(bins * sat_radiuses)) = 0;

    %---------- START DATASET -------------
    for i=1:nFiles
        % Read the image
        im = imread(strcat(data_set,'/',files(i).name));
        % Convert the image into HSV
        im = rgb2hsv(im);
        
        maskRes = color_segmentation(im, th_eval, bins, red_hist, blue_hist, rb_hist);
        if(7~=exist([data_set, '\result_masks\color_segmentation\'],'dir'))
            mkdir([data_set, '\result_masks\color_segmentation\']);
        end
        imwrite(maskRes,[data_set '\result_masks\color_segmentation\' strrep(files(i).name, '.jpg', '.png')]);

    end
    %---------- END DATASET -------------

    totalTime = toc;
    time = totalTime/nFiles;
end