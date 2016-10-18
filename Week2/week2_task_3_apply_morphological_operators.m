function outMasksDir = week2_task_3_apply_morphological_operators(dirMask)
%week2_task_3_apply_morphological_operators
%   Use morphological operators to improve results on color segmentation
%
%   Parameters
%       'dirMask' - Path to the input masks folder
%   Return
%       'outMasksDir' - Path to the output masks folder

input_masks = ListFiles(dirMask);
if(size(input_masks,1) == 0)
    return;
end

outMasksDir = [dirMask '\MO_masks\'];
if(7~=exist(outMasksDir,'dir'))
    mkdir(outMasksDir);
end

figure,
for idx = 1:size(input_masks,1)
   in_mask = imread([dirMask '\' input_masks(idx).name]);
   
   out_mask = apply_morphological_operators(in_mask);
   
   imwrite(out_mask,[outMasksDir input_masks(idx).name]);
   
   subplot(1,2,1), imshow(in_mask, [0,1]), title('input mask')
   subplot(1,2,2), imshow(out_mask, [0,1]), title('output mask')
end

end