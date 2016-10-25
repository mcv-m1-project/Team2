close all
%This function uses the previous computed train or validation masks to
%apply signal detection methods and compute an upgraded mask

% Add paths
addpath('..\')
addpath('..\Week1\')
addpath('..\Week2\')
addpath('..\Week3\')
addpath('..\evaluation\')
dirTrainDataSet = [pwd, '\..\..\train'];
%Path to the train set truth masks
dirGroundTruthMask = [pwd '\..\..\train\mask'];

% Get the signal main parameters
[signals, signals_list, nrepetitions, min_size, max_size, form_factor, filling_ratio, fr_means, ff_means] = get_signals_main_parameters(dirTrainDataSet, [dirTrainDataSet, '\gt'], [dirTrainDataSet, '\mask']);
%load('signals_main_parameters.mat');

%Path to the masks where to the signal detection method
% This path can be to the training or to the validation set
% method_name is the folder name where the color segmentation algorithm has
% stored the output masks
inputMasksDir = [dirTrainDataSet, '\results\method_name\train\'];
%inputMasksDir = [dirTrainDataSet, '\results\method_name\validation\'];

input_masks = ListFiles(inputMasksDir);
if(size(input_masks,1) == 0)
    return;
end

% detection_method is the folder name where we are going to store the
% upgraded masks
outMasksDir = [inputMasksDir '\detection_method\'];
if(7~=exist(outMasksDir,'dir'))
    mkdir(outMasksDir);
end

fprintf('\nMethod computation time:\n')
tic
%figure,
for idx = 1:size(input_masks,1)
   in_mask = imread([inputMasksDir '\' input_masks(idx).name]);
   
   %Call the detection method function and compute the upgraded mask
   %out_mask = detection_method(in_image, ...);
   
   imwrite(out_mask,[outMasksDir input_masks(idx).name]);
   
%    subplot(1,2,1), imshow(in_mask, [0,1]), title('input mask')
%    subplot(1,2,2), imshow(out_mask, [0,1]), title('output mask')
end
toc

[precision,accuracy,recall,F,TP,FP,FN] = evaluation( dirGroundTruthMasks, outMasksDir);
% save('evaluation_mo_results', 'precision', 'accuracy', 'recall',...
% 'F', 'TP', 'FP', 'FN' );

% Summary of signal types:
fprintf('\nSummary of evaluation results:\n')
 fprintf(['Precision | Accuracy | Recall | F | ', ...
             'TP | FP | FN |\n'])
for i = 1:size(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             precision(i), accuracy(i), recall(i), F(i), ...
             TP(i), FP(i), FN(i))
end

