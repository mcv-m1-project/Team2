function templateMatchingSweepCorrelation( dirTrain )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
addpath('..\evaluation')
addpath('..')
tic
files = ListFiles(dirTrain);
nFiles = length(files);

grayModels = load('grayModels');
colorModels = load('colorModels');
HISTTrain = fopen('template_matching_train_color.txt','w');
if(7~=exist([dirTrain, '\result_masks\templateMatching\'],'dir'))
    mkdir([dirTrain, '\result_masks\templateMatching\']);
end
% pVec = [];
% rVec = [];

for th=0.4:0.1:0.4
%     TP = 0;
%     FP = 0;
%     FN = 0;
%     TN = 0;
    for i=1:round(nFiles)
        i
        fileId = files(i).name(1:9);
        im = imread([dirTrain '\' fileId '.jpg']);
        [mask, windowCandidates] = templateMatchingSweep( im, grayModels, 'correlation', th );
%         [mask, windowCandidates] = templateMatchingSweepColor( im, colorModels, 'correlation', th );
%         mask = templateMatchingSweep( im, grayModels, 'substraction', 1.7343e+06 );
%         mask = templateMatchingSweepColor( im, colorModels, 'substraction', th );
        imwrite(mask,[dirTrain '\result_masks\templateMatching\' fileId '.png']);
        save([dirTrain '\result_masks\templateMatching\' fileId '.mat'],'windowCandidates');
%         imGroundTruth = imread([dirTrain '\mask\mask.' fileId '.png']);
%         [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(mask, imGroundTruth);
%         TP = TP + pixelTP;
%         FP = FP + pixelFP;
%         FN = FN + pixelFN;
%         TN = TN + pixelTN;
    end
%     [precision, accuracy, pixelSpecificity, recall] = PerformanceEvaluationPixel(TP, FP, FN, TN)
%     F1 = 2*(precision*recall/(precision+recall))
%     fprintf(HISTTrain, 'Th: %f, Precision: %f, Accuracy: %f, Recall: %f, F1 score: %f, TP: %f, FP: %f, FN: %f \n', th, precision, accuracy, recall, F1, TP, FP, FN);
%     pVec = [pVec precision];
%     rVec = [rVec recall];
end
% save('p_r_color','pVec','rVec');
totalTime = toc;
time = totalTime/nFiles
end

