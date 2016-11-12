function [precision,accuracy,recall,F,TP,FP,FN] = evaluation( dirGroundTruth, dirResult )
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

images = ListFiles(dirResult);
nFiles = length(images);
TP = 0;
FP = 0;
FN = 0;
TN = 0;

for i=1:nFiles
    imGroundTruth = imread([dirGroundTruth '\mask.' images(i).name]);
    %%imGroundTruth = imread([dirGroundTruth '\mask.' images(i).name]);
    imResult = imread([dirResult images(i).name]);
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(imResult(:,:,1), imGroundTruth);
    TP = TP + pixelTP;
    FP = FP + pixelFP;
    FN = FN + pixelFN;
    TN = TN + pixelTN;
end

[precision, accuracy, pixelSpecificity, recall] = PerformanceEvaluationPixel(TP, FP, FN, TN);

F = 2*(precision*recall/(precision+recall));
end

