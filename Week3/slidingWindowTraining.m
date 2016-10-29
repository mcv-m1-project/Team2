function [precisionVec,recallVec,F1Vec,widthVec,heightVec] = slidingWindowTraining(data_train,fillingFactor,minSize,maxSize)

minWidth = min(round(sqrt(minSize.*fillingFactor)));
minHeight = min(round(sqrt(minSize./fillingFactor)));

maxWidth = max(round(sqrt(maxSize.*fillingFactor)));
maxHeight = max(round(sqrt(maxSize./fillingFactor)));

files = listFiles(data_train);
nFiles = length(files);

precisionVec = [];
recallVec = [];
F1Vec = [];
widthVec = [];
heightVec = [];

for width=minWidth:10:maxWidth
    for height=minHeight:10:maxHeight
        stepW = round(0.2*width);
        stepH = round(0.2*height);
        
        TP = 0;
        FN = 0;
        FP = 0;
        for i=1:nFiles
            im = imread([data_train '\result_masks\morphological_operators\' strrep(files(i).name, '.jpg', '.png')]);
            [mask, windowCandidates] = slidingWindowImage(im, width, height, stepW, stepH);
            [annotations Signs] = LoadAnnotations([data_train '\gt\gt.' fileId '.txt']);
            [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowCandidates, annotations);
            TP = TP + localTP;
            FN = FN + localFN;
            FP = FP + localFP;
        end
        [precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP)
        F1 = 2*precision*recall/(precision+recall);
        
        precisionVec = [precisionVec precision];
        recallVec = [recallVec recall];
        F1Vec = [F1Vec F1];
        widthVec = [widthVec width];
        heightVec = [heightVec height];
    end
end
end