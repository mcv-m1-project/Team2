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
% Path to test images:
dirtest = [dirbase, '\..\..\test'];

dirMask_sb = [dirimage, '\result_masks\bp_sb'];
dirMask_mod = [dirimage, '\result_masks\bp_mod'];
dirMask_kde = [dirimage, '\result_masks\bp_kde'];

% We add the path where some scripts are.
addpath([dirbase, '\..\evaluation\'])
addpath([dirbase, '\auxiliar\'])
addpath([dirbase, '\..\'])

% Load signals vector.
load([pwd, '\..\Week1\signals_workspace']);

% Train / validation split:
[trainSet, validationSet] = train_validation_split(dirimage, nrepetitions);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% APPLY MORPHOLOGICAL OPERATORS %%%

% Swain-Ballard:
week2_task_3_apply_morphological_operators(dirMask_sb, dirmask, ...
    min_size, max_size, form_factor, filling_ratio)

% Swain-Ballard modified:
week2_task_3_apply_morphological_operators(dirMask_mod, dirmask, ...
    min_size, max_size, form_factor, filling_ratio)

% KDE:
week2_task_3_apply_morphological_operators(dirMask_kde, dirmask, ...
    min_size, max_size, form_factor, filling_ratio)