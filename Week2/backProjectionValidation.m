function [precision,accuracy,recall,F,TP,FP,FN] = backProjectionValidation( dirTrainDataSet, validationSet)
%BACKPROJECTIONVALIDATION
%Funtion to validate the color segmentation system based on histogram back-projection
%   Parameters
%       'dirTrainDataSet' - Path to the training set
%       'validationSet' - Vector containing the validation set (resulting from the train/validation split) identifiers
%   Returns
%       'precision'
%       'accuracy'
%       'recall'
%       'F' - F measure
%       'TP' - number of True Positive pixels
%       'FP' - number of False Positive pixels
%       'FN' - number of False Negative pixels

tic

hist = load('back-projection-Lab');
hist_g1 = hist.hist_g1;
hist_g2 = hist.hist_g2;
hist_g3 = hist.hist_g3;

th_g1=hist.th_g1;
th_g2=hist.th_g2;
th_g3=hist.th_g3;

TP = 0;
FP = 0;
FN = 0;
TN = 0;

for image=1:length(validationSet)
	im_orig = imread([dirTrainDataSet '\' validationSet{image} '.jpg']);
	[mask] = maskCalculation(im_orig, hist_g1,hist_g2,hist_g3, th_g1, th_g2,th_g3);
    imwrite(mask,[dirTrainDataSet '\result_masks\back-projection\validation\' validationSet{image} '.png']);
    imGroundTruth = imread([dirTrainDataSet '\mask\mask.' validationSet{image} '.png']);
	[pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(mask, imGroundTruth);
	TP = TP + pixelTP;
	FP = FP + pixelFP;
	FN = FN + pixelFN;
	TN = TN + pixelTN;
end

[precision, accuracy, pixelSpecificity, recall] = PerformanceEvaluationPixel(TP, FP, FN, TN);
F = 2*precision*recall/(precision+recall);

toc

end

