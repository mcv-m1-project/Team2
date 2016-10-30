addpath('..\')
addpath('..\evaluation\')
load('signals_main_parameters.mat');

dataSetSelected = [pwd, '\..\..\train'];
%dataSetSelected = [pwd, '\..\..\validation'];
inputMasksDir = [dataSetSelected, '\result_masks\morphological_operators\'];
%Path to the train set truth masks
dirGroundTruthMasks = [dataSetSelected '\mask'];

[bestRecall, bestSize, bestFf] = slidingWindowTraining(dataSetSelected,ff_means,min_size,max_size);


% % Summary of signal types:
% fprintf('\nSummary of region based evaluation results:\n')
%  fprintf(['Precision | Recall | F1 | ', ...
%              'Width | Height |\n'])
% for i = 1:size(precisionVec,2)
%     fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t', ...
%              '%5.0f | %5.0f |\n'], ...
%              precisionVec(i), recallVec(i), F1Vec(i), ...
%              widthVec(i), heightVec(i))
% end
