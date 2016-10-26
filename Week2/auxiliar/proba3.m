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
[trainABC, trainDF, trainE] = separate_list_groups(trainSet, signals);
[validationABC, validationDF, validationE] = separate_list_groups(validationSet, signals);

% Create train and validation signals vectors for each group:
% ABC:
[signals_ABC_train, signals_ABC_validation] = separate_signals_train(trainABC, validationABC, signals);
% DF:
[signals_DF_train, signals_DF_validation] = separate_signals_train(trainDF, validationDF, signals);
% E:
[signals_E_train, signals_E_validation] = separate_signals_train(trainE, validationE, signals);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


train_signals = signals_ABC_train;
trainSet = trainABC;
validationSet = validationABC;




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
nbins = 60;
threshold = 0.999999;
colorspace = 'lab';

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training backprojection:
R = backprojection_mod_train(gridx, gridy, colorspace, Xin, Xout, 1, 1);
% Computed mask:
computed_mask = backprojection_mod_run(validation_images{12}, R, ...
                    gridx, gridy, colorspace, r, threshold, 1);
% Performance evaluation:
[TP, FP, FN, TN] = PerformanceAccumulationPixel(computed_mask, validation_masks{i})




