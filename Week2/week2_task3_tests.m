% Tests

close all
% We add the path where some scripts are.
addpath('..\')
addpath('..\Week1\')
addpath('..\evaluation\')
dirTrainDataSet = [pwd, '\..\..\train'];

get_signals_main_parameters(dirTrainDataSet, [dirTrainDataSet, '\gt'], [dirTrainDataSet, '\mask']);
load('signals_info.mat');

%Path to the masks where to apply the morphological operators
dirMask_MO = [pwd, '\..\..\train\result_mask\RBT\validation'];
%Train truth masks
dirGroundTruthMask = [pwd '\..\..\train\mask'];

outMasksDir = week2_task_3_apply_morphological_operators(dirMask_MO, dirGroundTruthMask);