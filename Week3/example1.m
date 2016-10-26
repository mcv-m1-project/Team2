%%%%%%%%%%%%%%%%%%%%%%%%%
%%% *****

clear all
close all

% Base path:
dirbase = pwd;
% Path do data set:
dirimage = [dirbase, '\..\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirimage, '\gt'];
% Path to Masks:
dirmask = [dirimage, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\segmentation_methods\'])
addpath('..\Week1\')
addpath('..\Week2\')
addpath('auxiliar\')
addpath('..\evaluation\')

% Load signals vector.
load('signals_workspace');

% Train / validation split:
[trainSet, validationSet] = train_validation_split_mod(dirimage, nrepetitions);



%%%%%%%%%%%%%%%
% Method choice:
% method = 'mod2_3groups';
method = 'RBT';

% Loading parameters and defining run function:
if(strcmp(method,'mod2_3groups'))
    load('bp_mod2_3groups_params.mat')
    runfun = @run_mod2_3groups;
    
elseif(strcmp(method,'RBT'))
    load('RBT_thresholds_blue.mat')
    load('RBT_thresholds_red.mat')
    params.thresholds_blue = thresholds_blue;
    params.thresholds_red = thresholds_red;
    params.colorspace = 'lab';
    runfun = @RBT_mask;
    
else
    error('Method not recognized.')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% RUN AS MANY TIMES AS YOU WANT %%%%%%%%%
% Compute on random image from validation set:
run_random(validationSet, dirimage, runfun, params)



