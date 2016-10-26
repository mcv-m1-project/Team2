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
addpath('\auxiliar\')
addpath('..\evaluation\')

% Load signals vector.
load('signals_workspace');

% Train / validation split:
[trainSet, validationSet] = train_validation_split_mod(dirimage, nrepetitions);



%%%%%%%%%%%%%%%

% Loading parameters and defining run function:
clear params
load('bp_mod2_3groups_params.mat')
params1 = params;
runfun1 = @run_mod2_3groups;

clear params
load('RBT_thresholds_blue.mat')
load('RBT_thresholds_red.mat')
params2.thresholds_blue = thresholds_blue;
params2.thresholds_red = thresholds_red;
params2.colorspace = 'lab';
runfun2 = @RBT_mask;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% RUN AS MANY TIMES AS YOU WANT %%%%%%%%%
% Compute on random image from validation set:
run_random2(validationSet, dirimage, runfun1, params1, runfun2, params2)



