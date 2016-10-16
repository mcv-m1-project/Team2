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

%Load variables from week1_task1 to save computation time
load('signals_workspace.mat');

%Separate the train from the validation images
[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

% Test different segmentation methods and save the result masks in
% /train/result_mask/$(method) folder

% Hand Picked Lab Color Space Masks
week1_task3_hand_picked_masks(dirTrainDataSet, trainSet)

% 1D Histogram Method
week1_task3_signal_types_1D_histograms(dirTrainDataSet, trainSet, signals)

% 2D Histogram Method
week1_task3_signal_types_2D_ab_histograms(dirTrainDataSet, trainSet, signals)

% RBT Method
week1_task3_RBT(dirTrainDataSet, trainSet, validationSet, signals)









