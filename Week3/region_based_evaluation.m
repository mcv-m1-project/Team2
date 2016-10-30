function [precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirGroundTruth, dirBBoxResults)
%evaluation
%   Function to evaluate the result obtained with the Traffic Signal
%   detection system
%
%   Parameters
%       'dirGroundTruth' - Path where the ground truth binary images are
%       saved
%       'dirBBoxResults' - Path where the BBoxes from the detection method
%       are saved
%
%   Return
%       'precision'
%       'sensitivity'
%       'recall'
%       'TP' - True Positive objects
%       'FN' - False Negative objects
%       'FP' - False Positive objects


files = listFiles(dirGroundTruth);
nFiles = length(files);
TP = 0;
FP = 0;
FN = 0;

for i=1:nFiles
    fileId = files(i).name(1:end-4);
    detections = load([dirBBoxResults '\.' fileId '.mat']);
    [annotations Signs] = LoadAnnotations([dirGroundTruth '\gt\gt.' fileId '.txt']);

    [regionTP, regionFN, regionFP] = PerformanceAccumulationWindow(detections.windowCandidates, annotations);
    TP = TP + regionTP;
    FN = FN + regionFN;
    FP = FP + regionFP;
end

[precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
F1 = 2*precision*recall/(precision+recall);

end