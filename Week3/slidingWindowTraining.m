function [precisionVec,recallVec,F1Vec,widthVec,heightVec] = slidingWindowTraining(data_train,formFactor,minSize,maxSize)

minWidth = min(round(sqrt(minSize.*formFactor)));
minHeight = min(round(sqrt(minSize./formFactor)));

maxWidth = max(round(sqrt(maxSize.*formFactor)));
maxHeight = max(round(sqrt(maxSize./formFactor)));

% signals_size.max_width = sqrt(max(form_factor)*max(max_size));
% signals_size.min_width = sqrt(min(form_factor)*min(min_size));
% signals_size.max_height = sqrt(max(max_size)/min(form_factor));
% signals_size.min_height = sqrt(min(min_size)/max(form_factor));

files = listFiles(data_train);
nFiles = length(files);

precisionVec = [];
recallVec = [];
F1Vec = [];
widthVec = [];
heightVec = [];

for width=minWidth:round((maxWidth-minWidth)/5):maxWidth
    for height=minHeight:round((maxHeight-minHeight)/5):maxHeight
        stepW = round(0.2*width);
        stepH = round(0.2*height);
        
        TP = 0;
        FN = 0;
        FP = 0;
        for i=1:nFiles
            fileId = files(i).name(1:9);
            im = imread([data_train '\result_masks\morphological_operators\' fileId '.png']);
            [mask, windowCandidates] = slidingWindowImage(im, width, height, stepW, stepH);
            %[mask, windowCandidates] = slidingWindowIntegralImage(im, width, height, stepW, stepH);
            if(size(windowCandidates,2)~=0)
                [annotations Signs] = LoadAnnotations([data_train '\gt\gt.' fileId '.txt']);
                [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowCandidates, annotations);
                TP = TP + localTP;
                FN = FN + localFN;
                FP = FP + localFP;
            end
        end
        [precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
        F1 = 2*precision*recall/(precision+recall);
        
        precisionVec = [precisionVec precision];
        recallVec = [recallVec recall];
        F1Vec = [F1Vec F1];
        widthVec = [widthVec width];
        heightVec = [heightVec height];
    end
end
end