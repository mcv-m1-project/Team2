function [bestRecall, bestSize, bestFf] = slidingWindowTraining(data_train,formFactor,minSize,maxSize)

minSize = min(minSize);
maxSize = max(maxSize);
minFf = min(formFactor);
maxFf = max(formFactor);

files = listFiles(data_train);
nFiles = length(files);

precisionVec = [];
recallVec = [];
F1Vec = [];
sizeVec = [];
ffVec = [];

for size=minSize:(maxSize-minSize)/5:maxSize
    for ff=minFf:(maxFf-minFf)/5:maxFf
        width = round(sqrt(size.*ff));
        height = round(sqrt(size./ff));
        
        stepW = round(0.1*width);
        stepH = round(0.1*height);
        
        TP = 0;
        FN = 0;
        FP = 0;
        for i=1:nFiles
            fileId = files(i).name(1:9);
            im = imread([data_train '\result_masks\morphological_operators\' fileId '.png']);
            [~, windowCandidates] = slidingWindowImage(im, width, height, stepW, stepH);
            %[mask, windowCandidates] = slidingWindowIntegralImage(im, width, height, stepW, stepH);
            [annotations, ~] = LoadAnnotations([data_train '\gt\gt.' fileId '.txt']);
            [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowCandidates, annotations);
            TP = TP + localTP;
            FN = FN + localFN;
            FP = FP + localFP;

        end
        [precision, recall, ~] = PerformanceEvaluationWindow(TP, FN, FP);
        F1 = 2*precision*recall/(precision+recall);
        
        precisionVec = [precisionVec precision];
        recallVec = [recallVec recall];
        F1Vec = [F1Vec F1];
        sizeVec = [sizeVec size];
        ffVec = [ffVec ff];
    end
end

sizeMat = reshape(sizeVec,[6,6]);
precisionMat = reshape(precisionVec,[6,6]);
recallMat = reshape(recallVec,[6,6]);
ffMat = reshape(ffVec,[6,6]);
F1Mat = reshape(F1Vec,[6,6]);

bestF1 = max(max(F1Mat));
bestRecall = max(max(recallMat));
bestSize = sizeMat(recallMat==bestRecall);
bestFf = ffMat(recallMat==bestRecall);

plot(recallMat(:,1),precisionMat(:,1),'b.-',recallMat(:,2),precisionMat(:,2),'g.-',recallMat(:,3),precisionMat(:,3),'r.-',recallMat(:,4),precisionMat(:,4),'m.-',recallMat(:,5),precisionMat(:,5),'y.-',recallMat(:,6),precisionMat(:,6),'c.-')
title('Steps = 10% window size')
xlabel('Recall')
ylabel('Precision')
lgd = legend(num2str(sizeMat(1,1)),num2str(sizeMat(1,2)),num2str(sizeMat(1,3)),num2str(sizeMat(1,4)),num2str(sizeMat(1,5)),num2str(sizeMat(1,6)));
title(lgd,'Window size')
end