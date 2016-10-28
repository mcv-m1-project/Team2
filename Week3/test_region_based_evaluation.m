dirGroundTruthAnnotations = [dataSetSelected '\gt'];
%Obtained BBoxes with task1 or task2
dirBBoxesDetected = [dataSetSelected '\result_masks\window_method\gt'];
[precision, sensitivity, accuracy, TP, FN, FP] = region_based_evaluation(dirGroundTruthAnnotations, dirBBoxesDetected);

% Summary of signal types:
fprintf('\nSummary of region based evaluation results:\n')
 fprintf(['Precision | Accuracy | sensitivity | ', ...
             'TP | FP | FN |\n'])
for i = 1:size(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             precision(i), accuracy(i), sensitivity(i), ...
             TP(i), FP(i), FN(i))
end