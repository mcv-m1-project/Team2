function week1_task3_RBT(dirTrainDataSet, trainSet, validationSet, signals)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset
%       'trainSet' - Array of images used for training
%       'signals' - Array of objects with all the information about each signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Must be run only ONCE %%%%%%%%%%%%%%%%%%%%%
% ngrid = 20;
% RBT_prepare(trainSet, signals, image_list, dirTrainDataSet, mask_list, dirmask, ngrid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% To run when tuning parameters of RBT need to be changed %%%%
% min_percenin_blue = 50;
% min_percenin_red = 40;
% % This selects the thresholds that maximize the ratio and resepct the
% % minimum percentage especified for pixels found in signals. Then it writes
% % this thresholds to disk:
% RBT_select(min_percenin_blue, min_percenin_red)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
% Write masks for every image of the validation set:
for file = 1:length(validationSet)
    image = imread([dirTrainDataSet '\' validationSet{file} '.jpg']);
    mask = RBT_mask(image);
    imwrite(mask, [dirTrainDataSet '\result_mask\RBT\validation\' validationSet{file} '.png']);
end
toc
end

