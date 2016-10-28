function [time] = morphological_operators(data_set)

tic
    
files = listFiles([data_set '\result_masks\color_segmentation']);
nFiles = size(files, 1);

for i = 1:nFiles
    %Read original mask
    mask = imread([data_set,'\result_masks\color_segmentation\',files(i).name]);
    SE = strel('square', 3);
    mask = imopen(mask,SE);
    SE = strel('square', 5);
    mask = imclose(mask,SE);
    mask = imfill(mask);
    if(7~=exist([data_set, '\result_masks\morphological_operators\'],'dir'))
        mkdir([data_set, '\result_masks\morphological_operators\']);
    end
    imwrite(mask,[data_set, '\result_masks\morphological_operators\', files(i).name]);
end
    
    
totalTime = toc;
time = totalTime/nFiles;


end