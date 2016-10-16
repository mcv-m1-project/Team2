clear all
close all
% We add the path where some scripts are.
addpath('..\evaluation\')
addpath('..\colorspace\')
addpath('..\..\train\')

% Base directory:
dirbase = pwd;
% Path to the training dataset images
dirTrainDataSet = [dirbase, '\..\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirTrainDataSet, '\gt'];
% Path to Masks:
dirmask = [dirTrainDataSet, '\mask'];

week1_task1(dirTrainDataSet, dirgt, dirmask);

%Separate the train from the validation images
[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

% Test different segmentation methods and save the result masks in
% /train/result_mask/$(method) folder
dirGroundTruth = dirmask;

% Hand Picked Lab Color Space Masks
week1_task3_hand_picked_masks(dirTrainDataSet, validationSet)

dirResult = [dirTrainDataSet '\result_mask\hand_picked\validation\' ];
[precision_hand,accuracy_hand,recall_hand,F_hand,TP_hand,FP_hand,FN_hand] = evaluation( dirGroundTruth, dirResult )

% Lab Color Space 1D Histogram Method
week1_task3_signal_types_1D_histograms(dirTrainDataSet, trainSet, signals)
% % Save the validation split result masks
week1_task3_signal_types_1D_histograms_validation(dirTrainDataSet, validationSet)

dirResult = [dirTrainDataSet '\result_mask\1D_histogram\validation\' ];
[precision_1d_hist,accuracy_1d_hist,recall_1d_hist,F_1d_hist,TP_1d_hist,FP_1d_hist,FN_1d_hist] = evaluation( dirGroundTruth, dirResult )

% Lab Color Space 2D Histogram Method
% Execute the method once to obtain the desired thresholds using the train split
week1_task3_signal_types_2D_ab_histograms(dirTrainDataSet, trainSet, signals)
% Save the validation split result masks
week1_task3_signal_types_2D_ab_histograms_validation(dirTrainDataSet, validationSet)

dirResult = [dirTrainDataSet '\result_mask\2D_hist\validation\' ];
[precision_2d_hist,accuracy_2d_hist,recall_2d_hist,F_2d_hist,TP_2d_hist,FP_2d_hist,FN_2d_hist] = evaluation( dirGroundTruth, dirResult )

% RBT Method
%Run the train algorithm only once
week1_task3_RBT_train(dirTrainDataSet, trainSet, signals, image_list, mask_list, dirmask)
% Save the validation split result masks
week1_task3_RBT_validation(dirTrainDataSet, validationSet)

dirResult = [dirTrainDataSet '\result_mask\RBT\validation\' ];
[precision_RBT,accuracy_RBT,recall_RBT,F_RBT,TP_RBT,FP_RBT,FN_RBT] = evaluation( dirGroundTruth, dirResult )











