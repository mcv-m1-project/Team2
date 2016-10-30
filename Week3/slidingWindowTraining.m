function [bestF1, bestSize, bestFf] = slidingWindowTraining(data_train,formFactor,minSize,maxSize)

% minWidth = min(round(sqrt(minSize.*formFactor)));
% minHeight = min(round(sqrt(minSize./formFactor)));
% 
% maxWidth = max(round(sqrt(maxSize.*formFactor)));
% maxHeight = max(round(sqrt(maxSize./formFactor)));

% signals_size.max_width = sqrt(max(form_factor)*max(max_size));
% signals_size.min_width = sqrt(min(form_factor)*min(min_size));
% signals_size.max_height = sqrt(max(max_size)/min(form_factor));
% signals_size.min_height = sqrt(min(min_size)/max(form_factor));

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
        
        stepW = round(0.4*width);
        stepH = round(0.4*height);
        
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
bestSize = sizeMat(F1Mat==bestF1);
bestFf = ffMat(F1Mat==bestF1);

plot(precisionMat(:,1),recallMat(:,1),'b.-',precisionMat(:,2),recallMat(:,2),'g.-',precisionMat(:,3),recallMat(:,3),'r.-',precisionMat(:,4),recallMat(:,4),'m.-',precisionMat(:,5),recallMat(:,5),'y.-',precisionMat(:,6),recallMat(:,6),'c.-')
title('Steps = 40% window size')
xlabel('Precision')
ylabel('Recall')
lgd = legend(num2str(sizeMat(1,1)),num2str(sizeMat(1,2)),num2str(sizeMat(1,3)),num2str(sizeMat(1,4)),num2str(sizeMat(1,5)),num2str(sizeMat(1,6)));
title(lgd,'Window size')
end