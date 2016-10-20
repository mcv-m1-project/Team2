function outMasksDir = week2_task_3_apply_morphological_operators(dirMask, dirGroundTruthMasks)
%week2_task_3_apply_morphological_operators
%   Use morphological operators to improve results on color segmentation
%
%   Parameters
%       'dirMask' - Path to the input masks folder
%   Return
%       'outMasks' - Path to the output masks folder
%       'dirGroundTruthMasks' - Path to the truth masks folder

input_masks = ListFiles(dirMask);
if(size(input_masks,1) == 0)
    return;
end

outMasksDir = [dirMask '\results_MO\'];
if(7~=exist(outMasksDir,'dir'))
    mkdir(outMasksDir);
end

%figure,
for idx = 1:size(input_masks,1)
   in_mask = imread([dirMask '\' input_masks(idx).name]);
   
   out_mask = apply_morphological_operators(in_mask);
   
   imwrite(out_mask,[outMasksDir input_masks(idx).name]);
   
%    subplot(1,2,1), imshow(in_mask, [0,1]), title('input mask')
%    subplot(1,2,2), imshow(out_mask, [0,1]), title('output mask')
end

[precision,accuracy,recall,F,TP,FP,FN] = evaluation( dirGroundTruthMasks, outMasksDir);
% save('ev_square_imerode_imfill', 'precision', 'accuracy', 'recall',...
% 'F', 'TP', 'FP', 'FN' );

% Summary of signal types:
fprintf('\nSummary of evaluation results:\n')
 fprintf(['Precision | Accuracy | Recall | F | ', ...
             'TP | FP | FN |\n'])
for i = 1:size(precision)
    fprintf(['%5.3f |\t%5.3f |\t%5.3f |\t%5.3f |\t', ...
             '%5.0f | %5.0f | %5.0f |\n'], ...
             precision(i), accuracy(i), recall(i), F(i), ...
             TP(i), FP(i), FN(i))
end

end