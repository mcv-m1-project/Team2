function [time] = slidingWindow(data_set)

tic
%Window parameters
width = 230;
height = 210;
stepW = round(0.5*width);
stepH = round(0.5*height);

files = listFiles(data_set);
nFiles = length(files);
if(7~=exist([data_set, '\result_masks\slidingWindow\'],'dir'))
    mkdir([data_set, '\result_masks\slidingWindow\']);
end
if(7~=exist([data_set, '\result_masks\slidingWindow\mask\'],'dir'))
    mkdir([data_set, '\result_masks\slidingWindow\mask\']);
end

TP = 0;
FN = 0;
FP = 0;
for i=1:nFiles
    fileId = files(i).name(1:9);
    im = imread([data_set '\result_masks\morphological_operators\' fileId '.png']);
    [mask, windowCandidates] = slidingWindowImage(im, width, height, stepW, stepH);
    %[mask, windowCandidates] = slidingWindowIntegralImage(im, width, height, stepW, stepH);
    imwrite(mask,[data_set '\result_masks\slidingWindow\mask\' fileId '.png']);
    save([data_set '\result_masks\slidingWindow\' fileId '.mat'],'windowCandidates');
    
    [annotations Signs] = LoadAnnotations([data_set '\gt\gt.' fileId '.txt']);
    [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowCandidates, annotations);
    TP = TP + localTP;
    FN = FN + localFN;
    FP = FP + localFP;
end

totalTime = toc;
time = totalTime/nFiles;
fprintf('Time: %f',time);
[precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
F1 = 2*precision*recall/(precision+recall);
save('region_evaluation_results', 'precision', 'recall', 'F1', 'width', 'height');

% Summary of signal types:
fprintf('\nSummary of region based evaluation results:\n')
 fprintf(['Precision | Recall | F1 | ', ...
             'Width | Height |\n'])
for i = 1:size(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f |\n'], ...
             precision(i), recall(i), F1(i), ...
             width(i), height(i))
end

[pixel_precision,pixel_accuracy,pixel_recall,pixel_F,pixel_TP,pixel_FP,pixel_FN] = evaluation( [data_set '\mask'], [data_set '\result_masks\slidingWindow\mask']);
save('pixel_evaluation_results', 'pixel_precision', 'pixel_accuracy', 'pixel_recall', 'pixel_F', 'pixel_TP', 'pixel_FP', 'pixel_FN' );

% Summary of signal types:
fprintf('\nSummary of the pixel evaluation results:\n')
 fprintf(['Precision | Accuracy | Recall | F | ', ...
             'TP | FP | FN |\n'])
for i = 1:size(pixel_precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             pixel_precision(i), pixel_accuracy(i), pixel_recall(i), pixel_F(i), ...
             pixel_TP(i), pixel_FP(i), pixel_FN(i))
end

end