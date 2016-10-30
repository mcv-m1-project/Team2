function [precision,recall,F1] = slidingVariousWindowTraining(data_train)

files = listFiles(data_train);
nFiles = length(files);

winSize=[11912,33915,55919];
ff = [0.9661,1.0669,1.0669];

TP = 0;
FN = 0;
FP = 0;
for i=1:nFiles
    fileId = files(i).name(1:9);
    im = imread([data_train '\result_masks\morphological_operators\' fileId '.png']);
    [mask, windowCandidates] = slidingVariousWindowsImage(im, winSize, ff, 0.3);
    %[mask, windowCandidates] = slidingWindowIntegralImage(im, width, height, stepW, stepH);
    [annotations, ~] = LoadAnnotations([data_train '\gt\gt.' fileId '.txt']);
    [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowCandidates, annotations);
    TP = TP + localTP;
    FN = FN + localFN;
    FP = FP + localFP;
    
end
[precision, recall, ~] = PerformanceEvaluationWindow(TP, FN, FP);
F1 = 2*precision*recall/(precision+recall);

end
