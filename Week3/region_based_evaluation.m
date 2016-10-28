function [precision, sensitivity, accuracy, TP, FN, FP] = region_based_evaluation(dirGroundTruth, dirBBoxResults)
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


bbox_annotation = dir(dirBBoxResults);
TP = 0;
FP = 0;
FN = 0;

for i=3:size(bbox_annotation)
    
    [detections Signs_detected] = LoadAnnotations([dirBBoxResults '\' bbox_annotation(i).name]);
    [annotations Signs] = LoadAnnotations([dirGroundTruth '\' bbox_annotation(i).name]);

    
    [regionTP, regionFN, regionFP] = PerformanceAccumulationWindow(detections, annotations);
    TP = TP + regionTP;
    FN = FN + regionFN;
    FP = FP + regionFP;
end

[precision, sensitivity, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);

end