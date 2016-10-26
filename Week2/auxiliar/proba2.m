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

% For tuning, we will take only a fraction of the train and validation
% sets:
percen_sets = 100;
% Train set:
ntrain = length(trainSet);
tags = randsample(ntrain, floor(ntrain * percen_sets / 100));
for i = 1:length(tags)
    aux{i} = trainSet{tags(i)};
end
trainSet = aux;
ntrain = length(trainSet);
% Validation set:
nvalidation = length(validationSet);
tags = randsample(nvalidation, floor(nvalidation * percen_sets / 100));
for i = 1:length(tags)
    aux{i} = validationSet{tags(i)};
end
validationSet = aux;
nvalidation = length(validationSet);

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

% Tuning parameters:
% Number of bins of histograms:
% nbins_vec = [10, 15, 25, 50];
nbins_vec = [25, 40];
% Threshold for binarizing:
% thresholds_vec = [0.8, 0.9, 0.95, 0.99];
thresholds_vec = [0.99, 0.995, 0.999];
% Radio of disk for convolution:
r_vec = [5];


figure()
for i = 1:25
    subplot(5,5,i)
    imshow(signals_ABC_train(i).image)
end

figure()
for i = 1:25
    subplot(5,5,i)
    imshow(signals_ABC_validation(i).image)
end



figure()
for i = 1:25
    subplot(5,5,i)
    imshow(signals_DF_train(i).image)
end

figure()
for i = 1:25
    subplot(5,5,i)
    imshow(signals_DF_validation(i).image)
end



figure()
for i = 1:25
    subplot(5,5,i)
    imshow(signals_E_train(i).image)
end

figure()
for i = 1:25
    subplot(5,5,i)
    imshow(signals_E_validation(i).image)
end


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
[Xin, ~] = create_Xin_Xout(train_signals, trainSet, dirimage, dirmask);

len_nbins = length(nbins_vec);
len_thresholds = length(thresholds_vec);
len_r = length(r_vec);

colorspace = 'lab';

% Arrays of evaluation results:
precision_array = zeros(len_nbins, len_thresholds, len_r);
recall_array = zeros(len_nbins, len_thresholds, len_r);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


r = 2;
nbins = 60;
threshold = 0.99;

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training backprojection:
M = backprojection_sb_train(gridx, gridy, colorspace, Xin, 1);
% Computed mask:
computed_mask = backprojection_sb_run(validation_images{5}, M, ...
                    gridx, gridy, colorspace, r, threshold, 1, 1);
% Performance evaluation:
[TP, FP, FN, TN] = PerformanceAccumulationPixel(computed_mask, validation_masks{i})




