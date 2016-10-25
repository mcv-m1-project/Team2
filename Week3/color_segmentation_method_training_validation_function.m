close all

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

%Separate the train from the validation images
[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

% Create a folder to store the resultant masks
% This path can be to the training or to the validation set
dataSetSelected = trainSet;
outMasksDir = [dirTrainDataSet, '\results\method_name\train\'];
%dataSetSelected = validationSet;
%outMasksDir = [dirTrainDataSet, '\results\method_name\validation\'];
if(7~=exist(outMasksDir,'dir'))
    mkdir(outMasksDir);
end

fprintf('\nMethod computation time:\n')
tic
%figure,
for idx = 1:size(trainSet,2)
   % Read the image
   in_image = imread([dirTrainDataSet '\' dataSetSelected{image} '.jpg']);
   
   %Call the method and compute the mask for signal detection
   %out_mask = color_segmentation_method(in_image, ...);
   
   %Store the resultant mask
   imwrite(out_mask,[outMasksDir dataSetSelected{image} '.png']);
   
%    subplot(1,2,1), imshow(in_image), title('input image')
%    subplot(1,2,2), imshow(out_mask, [0,1]), title('output mask')
end
toc

%Compute the pixel evaluation parameters for the method applied using the
%computed masks
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
