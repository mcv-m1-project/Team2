function week1_task3_RBT_validation(dirTrainDataSet, validationSet)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset
%       'trainSet' - Array of images used for training

% Write masks for every image of the validation set:
tic
for file = 1:length(validationSet)
    image = imread([dirTrainDataSet '\' validationSet{file} '.jpg']);
    mask = RBT_mask(image);
    imwrite(mask, [dirTrainDataSet '\result_mask\RBT\validation\' validationSet{file} '.png']);
end
toc
end

