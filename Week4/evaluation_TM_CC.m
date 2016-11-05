addpath('..\')
addpath('..\Week3\')
addpath('..\evaluation\')
load('signals_main_parameters.mat');

dirTrain = [pwd, '\..\..\train'];
inputMasksDir = [dirTrain, '\mask\'];
outputMasksDir = [dirTrain, '\result_masks\week4_task1_CC\'];

files = ListFiles(dirTrain);
nFiles = length(files);
    
%[CC_list]  = week3_task1(inputMasksDir, outputMasksDir);
tic
TP = 0;
FN = 0;
FP = 0;
        
for i=1:nFiles
    fileId = files(i).name(1:9);
    [annotations Signs] = LoadAnnotations([dirTrain '\gt\gt.' fileId '.txt']);
    windowsSelected = load([outputMasksDir fileId '.mat']);
    [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowsSelected.windowsSelected, annotations);
    TP = TP + localTP;
    FN = FN + localFN;
    FP = FP + localFP;
end

totalTime = toc;
time = totalTime/nFiles;
fprintf('Time: %f',time);
[precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
F1 = 2*precision*recall/(precision+recall);
%save('region_train_results_week4_task1_CC', 'precision', 'recall', 'F1', 'TP', 'FN', 'FP');

% Summary of signal types:
fprintf('\nSummary of region based evaluation results:\n')
 fprintf(['Precision | Recall | F1 | ', ...
             ' TP | FN | FP |\n'])
for i = 1:size(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             precision(i), recall(i), F1(i), TP(i), FN(i), FP(i))
end

[pixel_precision,pixel_accuracy,pixel_recall,pixel_F,pixel_TP,pixel_FP,pixel_FN] = evaluation( [dirTrain '\mask'], outputMasksDir);
%save('pixel_evaluation_results_week4_task1_CC', 'pixel_precision', 'pixel_accuracy', 'pixel_recall', 'pixel_F', 'pixel_TP', 'pixel_FP', 'pixel_FN' );

% Summary of signal types:
fprintf('\nSummary of the pixel evaluation results:\n')
 fprintf(['Precision | Accuracy | Recall | F | ', ...
             'TP | FP | FN |\n'])
for i = 1:size(pixel_precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             pixel_precision(i), pixel_accuracy(i), pixel_recall(i), pixel_F(i), ...
             pixel_TP(i), pixel_FP(i), pixel_FN(i))
end
