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

% For ABC, we will take only a fraction of the train and validation
% sets:
percen_sets = 50;
% Train set:
ntrainABC = length(trainABC);
tags = randsample(ntrainABC, floor(ntrainABC * percen_sets / 100));
aux = cell(0);
for i = 1:length(tags)
    aux{i} = trainABC{tags(i)};
end
trainABC = aux;
ntrainABC = length(trainABC);
% Validation set:
nvalidationABC = length(validationABC);
tags = randsample(nvalidationABC, floor(nvalidationABC * percen_sets / 100));
aux = cell(0);
for i = 1:length(tags)
    aux{i} = validationABC{tags(i)};
end
validationABC = aux;
nvalidationABC = length(validationABC);

% For DF, we will take only a fraction of the train and validation
% sets:
percen_sets = 50;
% Train set:
ntrainDF = length(trainDF);
tags = randsample(ntrainDF, floor(ntrainDF * percen_sets / 100));
aux = cell(0);
for i = 1:length(tags)
    aux{i} = trainDF{tags(i)};
end
trainDF = aux;
ntrainDF = length(trainDF);
% Validation set:
nvalidationDF = length(validationDF);
tags = randsample(nvalidationDF, floor(nvalidationDF * percen_sets / 100));
aux = cell(0);
for i = 1:length(tags)
    aux{i} = validationDF{tags(i)};
end
validationDF = aux;
nvalidationDF = length(validationDF);

% Create train and validation signals vectors for each group:
% ABC:
[signals_ABC_train, signals_ABC_validations] = separate_signals_train(trainABC, validationABC, signals);
% DF:
[signals_DF_train, signals_DF_validations] = separate_signals_train(trainDF, validationDF, signals);
% E:
[signals_E_train, signals_E_validations] = separate_signals_train(trainE, validationE, signals);

% Tuning parameters:
% Number of bins of histograms:
% nbins_vec = [10, 15, 25, 50];
nbins_vec = [25, 40, 60];
% Threshold for binarizing:
% thresholds_vec = [0.8, 0.9, 0.95, 0.99];
thresholds_vec = [0.9, 0.99, 0.999];
% Radio of disk for convolution:
r_vec = [1, 2, 5, 10];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab color space:
colorspace = 'lab';

% ABC:
[precision_array, recall_array] = tune_sb(signals_ABC_train, trainABC, validationABC, dirimage, ...
                                    dirmask, colorspace, nbins_vec, thresholds_vec, r_vec);
save('tuning_arrays_ABC_lab', 'precision_array', 'recall_array', 'nbins_vec', 'thresholds_vec', 'r_vec')

% % DF:
% [precision_array, recall_array] = tune_sb(signals_DF_train, trainDF, validationDF, dirimage, ...
%                                     dirmask, colorspace, nbins_vec, thresholds_vec, r_vec);
% save('tuning_arrays_DF_lab', 'precision_array', 'recall_array', 'nbins_vec', 'thresholds_vec', 'r_vec')
% 
% % E:
% [precision_array, recall_array] = tune_sb(signals_E_train, trainE, validationE, dirimage, ...
%                                     dirmask, colorspace, nbins_vec, thresholds_vec, r_vec);
% save('tuning_arrays_E_lab', 'precision_array', 'recall_array', 'nbins_vec', 'thresholds_vec', 'r_vec')
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % hsv color space:
% colorspace = 'hsv';
% 
% % ABC:
% [precision_array, recall_array] = tune_sb(signals_ABC_train, trainABC, validationABC, dirimage, ...
%                                     dirmask, colorspace, nbins_vec, thresholds_vec, r_vec);
% save('tuning_arrays_ABC_hsv', 'precision_array', 'recall_array', 'nbins_vec', 'thresholds_vec', 'r_vec')
% 
% % DF:
% [precision_array, recall_array] = tune_sb(signals_DF_train, trainDF, validationDF, dirimage, ...
%                                     dirmask, colorspace, nbins_vec, thresholds_vec, r_vec);
% save('tuning_arrays_DF_hsv', 'precision_array', 'recall_array', 'nbins_vec', 'thresholds_vec', 'r_vec')
% 
% % E:
% [precision_array, recall_array] = tune_sb(signals_E_train, trainE, validationE, dirimage, ...
%                                     dirmask, colorspace, nbins_vec, thresholds_vec, r_vec);
% save('tuning_arrays_E_hsv', 'precision_array', 'recall_array', 'nbins_vec', 'thresholds_vec', 'r_vec')


