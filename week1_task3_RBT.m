clear all
close all

% We add the path where some scripts are.
addpath('evaluation\')
addpath('colorspace\')
addpath('..\train\')

% Base directory:
dirbase = pwd;
% Path to the training dataset images
dirTrainDataSet = [dirbase, '\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirTrainDataSet, '\gt'];
% Path to Masks:
dirmask = [dirTrainDataSet, '\mask'];

% Load variables from week1_task1 to save computation time
load('signals_workspace.mat');

% Separate the train from the validation images
[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

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

% Write masks for every image of the validation set:
for file = 1:length(validationSet)
    image = imread([dirTrainDataSet '\' validationSet{file} '.jpg']);
    mask = RBT_mask(image);
    imwrite(mask, [dirTrainDataSet '\result_mask\RBT\maskRBT_' validationSet{file} '.png']);
end


