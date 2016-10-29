function [time] = slidingWindow(data_set)

tic
width = 1;
height = 1;
stepW = 5;
stepH = 5;

files = listFiles(data_set);
nFiles = length(files);
if(7~=exist([data_set, '\result_masks\slidingWindow\'],'dir'))
    mkdir([data_set, '\result_masks\slidingWindow\']);
end
for i=1:nFiles
    fileId = files(i).name(1:9);
    im = imread([data_set '\result_masks\morphological_operators\' fileId '.png']);
    [mask, windowCandidates] = slidingWindow(im, width, height, stepW, stepH);
    imwrite(mask,[data_set '\result_masks\slidingWindow\' fileId '.png']);
    save([data_set '\result_masks\slidingWindow\' fileId '.mat'],'windowCandidates');
end
totalTime = toc;
time = totalTime/nFiles;
end