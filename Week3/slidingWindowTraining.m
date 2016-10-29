function slidingWindowTraining(data_train,fillingFactor,minSize,maxSize)

minWidth = min(round(sqrt(minSize.*fillingFactor)));
minHigh = min(round(sqrt(minSize./fillingFactor)));

maxWidth = max(round(sqrt(maxSize.*fillingFactor)));
maxHigh = max(round(sqrt(maxSize./fillingFactor)));

files = listFiles(data_train);
nFiles = length(files);

for i=1:nFiles
    width = minWidth;
    height = minHigh;
    stepW = 5;
    stepH = 5;
    im = imread([data_train '\result_masks\morphological_operators\' strrep(files(i).name, '.jpg', '.png')]);
    [mask, windowCandidates] = slidingWindow(im, width, height, stepW, stepH);
    if(7~=exist([data_train, '\result_masks\slidingWindow\'],'dir'))
        mkdir([data_train, '\result_masks\slidingWindow\']);
    end
    imwrite(mask,[data_train '\result_masks\slidingWindow\' strrep(files(i).name, '.jpg', '.png')]);
    save([data_train '\result_masks\slidingWindow\' strrep(files(i).name, '.jpg', '.mat')],'windowCandidates');
    [precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirGroundTruth, dirBBoxResults);
end

end