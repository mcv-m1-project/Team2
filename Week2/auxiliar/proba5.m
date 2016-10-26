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

% Create separate lists for each group of signals:
[trainC, trainF, trainother] = separate_list_groups(trainSet, signals);
[validationC, validationF, validationother] = separate_list_groups(validationSet, signals);

% Create train and validation signals vectors for each group:
% ABC:
[signals_C_train, signals_C_validation] = separate_signals_train(trainC, validationC, signals);
% DF:
[signals_F_train, signals_F_validation] = separate_signals_train(trainF, validationF, signals);
% E:
[signals_other_train, signals_other_validation] = separate_signals_train(trainother, validationother, signals);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


train_signals = signals_C_train;
trainSet = trainC;
validationSet = validationC;




% Reading validation masks and images:
nvalidation = length(validationSet);
validation_images = cell(1, nvalidation);
validation_masks = cell(1, nvalidation);
for i = 1:nvalidation
    imagefile = [dirimage, '\', validationSet{i}, '.jpg'];
    validation_images{i} = imread(imagefile);
    maskfile = [dirmask, '\mask.', validationSet{i}, '.png'];
    validation_masks{i} = imread(maskfile);
end

% Create matrices with pixels in and outside train signals:
[Xin, Xout] = create_Xin_Xout(train_signals, trainSet, dirimage, dirmask);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


r = 2;
nbins = 100;
threshold = 0.999999;
colorspace = 'lab';

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

file = 35;

% Training backprojection:
[M, R1] = backprojection_mod2_train(gridx, gridy, colorspace, Xin, Xout, 0, 0);
% Computed mask:
computed_mask = backprojection_mod2_run(validation_images{file}, M, R1, ...
                    gridx, gridy, colorspace, r, threshold, 1);


% Training backprojection:
M = backprojection_sb_train(gridx, gridy, colorspace, Xin, 0);
% Computed mask:
computed_mask = backprojection_sb_run(validation_images{file}, M, ...
                    gridx, gridy, colorspace, r, threshold, 0, 1);




