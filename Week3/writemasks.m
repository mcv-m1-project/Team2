% Write validation masks obtained with RBT method.


clear all
close all



%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% Paths:
addpath('auxiliar')
addpath('previous')
addpath('segmentation_methods')
addpath('..\evaluation')



%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% Directories:
dirbase = pwd;
dirDataSet = [dirbase, '\..\..\train'];
dirValidation = [dirDataSet, '\..\validation'];
dirGroundTruth= [dirValidation, '\mask'];



%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% Method choice:

% method = 'mod2_3groups';
method = 'RBT';

% Loading parameters and defining run function:
if(strcmp(method,'mod2_3groups'))
    load('bp_mod2_3groups_params.mat')
    runfun = @run_mod2_3groups;
    dirWrite = [dirValidation, '\result_masks\mod2_3groups'];
    
elseif(strcmp(method,'RBT'))
    load('RBT_thresholds_blue.mat')
    load('RBT_thresholds_red.mat')
    params.thresholds_blue = thresholds_blue;
    params.thresholds_red = thresholds_red;
    params.colorspace = 'lab';
    runfun = @RBT_mask;
    dirWrite = [dirValidation, '\result_masks\RBT'];
    
else
    error('Method not recognized.')
end



%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% Compute and write masks:
write_validation_masks(dirValidation, dirWrite, runfun, params, dirGroundTruth)










