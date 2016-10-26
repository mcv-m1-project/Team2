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

% Parameters:
r = 2;
nbins = 100;
threshold = 0.999999;
colorspace = 'lab';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  training

[M_ABC, M_DF, M_E, R1_ABC, R1_DF, R1_E, gridx, gridy] = ...
    train_mod2_3groups(trainSet, validationSet, dirimage, dirmask, signals, nbins, colorspace);

% Storing parameters for running in structure:
params.M_ABC = M_ABC;
params.M_DF = M_DF;
params.M_E = M_E;
params.R1_ABC = R1_ABC;
params.R1_DF = R1_DF;
params.R1_E = R1_E;
params.nbins = nbins;
params.r = r;
params.threshold = threshold;
params.colorspace = colorspace;
params.gridx = gridx;
params.gridy = gridy;
save('bp_mod3_params.mat', 'params')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  running

file = 25;
imagefile = [dirimage, '\', validationSet{file}, '.jpg'];
image = imread(imagefile);

% Final mask:
final_mask = run_mod2_3groups(image, params);

% Show result:
figure()
subplot(1,2,1)
imshow(image)
title('Original image')
subplot(1,2,2)
imshow(final_mask, [0 1])
title('Final mask')




