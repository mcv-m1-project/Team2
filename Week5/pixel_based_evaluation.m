function [precision,accuracy,recall,F1,TP,FP,FN] = pixel_based_evaluation(dirGroundTruth,dirResult)
%evaluation
%   Function to evaluate the result obtained with the Traffic Signal
%   detection system
%
%   Parameters
%       'dirGroundTruth' - Path where the ground truth binary images are
%       saved
%       'dirResult' - Path where the obtained binary images are saved
%
%   Return
%       'precision'
%       'accuracy'
%       'recall'
%       'F' - F measure
%       'TP' - True Positive mask
%       'FP' - False Positive mask
%       'FN' - False Negative mask

images = listFiles(dirResult);
TP = 0;
FP = 0;
FN = 0;
TN = 0;

for i=1:size(images)
    imGroundTruth = imread([dirGroundTruth '\mask\mask.' images(i).name]);
    imResult = imread([dirResult '\' images(i).name]);
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(imResult, imGroundTruth);
    TP = TP + pixelTP;
    FP = FP + pixelFP;
    FN = FN + pixelFN;
    TN = TN + pixelTN;
end

[precision, accuracy, pixelSpecificity, recall] = PerformanceEvaluationPixel(TP, FP, FN, TN);

F1 = 2*(precision*recall/(precision+recall));

% Summary of signal types:
fprintf('\nSummary of pixel based evaluation results:\n')
 fprintf(['Precision | Accuracy | Recall | ', ...
             'TP | FP | FN |\n'])
for i = 1:size(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             precision(i), accuracy(i), recall(i), ...
             TP(i), FP(i), FN(i))
end

fprintf('F1 = %f\n', F1)

end

