%clear all
%close all
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

% Create lists with the ground truth annotations files, the mask files, and
% the original image files:
[gt_list, mask_list, images_list] = create_files_list(dirTrainDataSet);

% Counting of signals types in annotations in dirgt:
[signals_list, nrepetitions] = count_signals_types(dirgt, gt_list);

% Statistics about form factor:
form_factor = analyze_form_factor(dirgt, gt_list);

% Statistics about filling ratio:
filling_ratio = analyze_filling_ratio(dirgt, gt_list, dirmask, mask_list);

% Names of signals found:
fprintf('Names of signals found:\n')
signals_list

% Times each signal appears:
fprintf('Times each signal appears:\n')
nrepetitions

[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

%Every time an image is display it will wait for mouse click or enter to
%display the next one.
%week1_task3_color_segmentation_test( dirTrainDataSet, trainSet)
close all,
week1_task3_color_segmentation_equalization_test(dirTrainDataSet, trainSet)








