% Tests

% We add the path where some scripts are.
addpath('..\')
%addpath('..\colorspace\')

dirMask = [pwd, '\..\..\train\result_mask\RBT\validation'];

outMasksDir = week2_task_3_apply_morphological_operators(dirMask);