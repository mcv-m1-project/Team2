%%%%%%%%%%%%%%%%%%%%%%%%%
%%% *****

clear all
close all

% Base path:
dirbase = pwd;
% Path do data set:
dirimage = [dirbase, '\..\..\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirimage, '\gt'];
% Path to Masks:
dirmask = [dirimage, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\..\..\evaluation\'])
addpath([dirbase, '\..\'])

% Load signals vector.
load('signals_workspace');

% Train / validation split:
[trainSet, validationSet] = train_validation_split(dirimage, nrepetitions);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  validation


% For validating, we will take only a fraction of the validation set:
percen_sets = 30;
% Validation set:
nvalidation = length(validationSet);
tags = randsample(nvalidation, floor(nvalidation * percen_sets / 100));
validation_red = cell(0);
for i = 1:length(tags)
    validation_red{i} = validationSet{tags(i)};
end
nvalidation = length(validation_red);

% Loading parameters:

%%%%%%%%%%%%%%%
% Method choice:
% method = 'mod2_3groups';
method = 'RBT';

% Loading parameters and defining run function:
if(strcmp(method,'mod2_3groups'))
    load('bp_mod3_params.mat')
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


% Computing validation:
[precision, accuracy, recall, F1, TP, FP, FN, tpf] = ...
    measure_method_efficiency(validation_red, dirimage, dirmask, runfun, params)



