% Tests Week 2 task 3

close all
% We add the path where some scripts are.
addpath('..\')
addpath('..\Week1\')
addpath('..\evaluation\')
dirTrainDataSet = [pwd, '\..\..\train'];

% Get mininimum and maximum size for the signals
%[min_size, max_size, form_factor,filling_ratio] = get_signals_size_parameters(dirTrainDataSet, [dirTrainDataSet, '\gt'], [dirTrainDataSet, '\mask']);
load('signals_size_parameters.mat');

%Path to the masks where to apply the morphological operators
dirMask_MO = [pwd, '\..\..\train\result_mask\RBT\validation'];
%Path to the train set truth masks
dirGroundTruthMask = [pwd '\..\..\train\mask'];

% Apply the morphologic operator to all the mask images
outMasksDir = week2_task_3_apply_morphological_operators(dirMask_MO, dirGroundTruthMask, min_size, max_size, form_factor,filling_ratio);