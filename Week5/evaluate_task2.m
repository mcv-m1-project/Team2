close all,
addpath('..\')
addpath('..\evaluation')

%Paths
dirTestImages = [pwd, '\..\..\train'];
outputMasksDir = [dirTestImages, '\result_masks\week5_task2_hough_transform\'];
files = ListFiles(dirTestImages);
nFiles = length(files);
    
TP = 0;
FN = 0;
FP = 0;
        
for i=1:nFiles
    fileId = files(i).name(1:9);
    [annotations Signs] = LoadAnnotations([dirTestImages '\gt\gt.' fileId '.txt']);
    windowCandidates = load([outputMasksDir fileId '.mat']);
    [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowCandidates.windowCandidates, annotations);
    TP = TP + localTP;
    FN = FN + localFN;
    FP = FP + localFP;
end

[precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
F1 = 2*precision*recall/(precision+recall);
%save('region_train_results_week5_task2', 'precision', 'recall', 'F1', 'TP', 'FN', 'FP');

% Summary of signal types:
fprintf('\nSummary of region based evaluation results:\n')
 fprintf(['Precision | Recall | F1 | ', ...
             ' TP | FN | FP |\n'])
for i = 1:size(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             precision(i), recall(i), F1(i), TP(i), FN(i), FP(i))
end

[pixel_precision,pixel_accuracy,pixel_recall,pixel_F,pixel_TP,pixel_FP,pixel_FN] = evaluation( [dirTestImages '\mask'], outputMasksDir);
%save('pixel_evaluation_results_week5_task2', 'pixel_precision', 'pixel_accuracy', 'pixel_recall', 'pixel_F', 'pixel_TP', 'pixel_FP', 'pixel_FN' );

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
