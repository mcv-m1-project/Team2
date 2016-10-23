function outMasksDir = week2_task_3_apply_morphological_operators(dirMask, dirGroundTruthMasks, min_size, max_size, form_factor, filling_ratio)
%week2_task_3_apply_morphological_operators
%   Use morphological operators to improve results on color segmentation
%
%   Parameters
%       'dirMask' - Path to the input masks folder
%       'dirGroundTruthMasks' - Path to the truth masks folder
%       'min_size' - Minimum signal sizes
%       'max_size' - Maximum signal sizes
%       'form_factor' - Signals form factors
%       'filling_ratio' - Signals filling ratio
%   Return
%       'outMasks' - Path to the output masks folder

input_masks = ListFiles(dirMask);
if(size(input_masks,1) == 0)
    return;
end

outMasksDir = [dirMask '\results_MO\'];
if(7~=exist(outMasksDir,'dir'))
    mkdir(outMasksDir);
end

%Compute maximum and minimum width
signals_size.min_area = floor(min(min_size)*min(filling_ratio));
signals_size.max_area = floor(max(max_size)*max(filling_ratio));
signals_size.max_width = sqrt(max(form_factor)*max(max_size));
signals_size.min_width = sqrt(min(form_factor)*min(min_size));
signals_size.max_height = sqrt(max(max_size)/min(form_factor));
signals_size.min_height = sqrt(min(min_size)/max(form_factor));

%figure,
for idx = 1:size(input_masks,1)
   in_mask = imread([dirMask '\' input_masks(idx).name]);
   
   out_mask = apply_morphological_operators(in_mask, signals_size);
   
   imwrite(out_mask,[outMasksDir input_masks(idx).name]);
   
%    subplot(1,2,1), imshow(in_mask, [0,1]), title('input mask')
%    subplot(1,2,2), imshow(out_mask, [0,1]), title('output mask')
end

[precision,accuracy,recall,F,TP,FP,FN] = evaluation( dirGroundTruthMasks, outMasksDir);
% save('evaluation_mo_results', 'precision', 'accuracy', 'recall',...
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