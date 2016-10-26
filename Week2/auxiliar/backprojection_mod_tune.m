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
addpath([dirbase, '\..\evaluation\'])

% Load signals vector.
load('signals_workspace');

% Train / validation split:
[trainSet, validationSet] = train_validation_split(dirimage, nrepetitions);

% For this purpose, we take only half of the validation set:
nvalidation = length(validationSet);
tags = randsample(nvalidation, floor(nvalidation/2));
aux = cell(1,length(tags));
for i = 1:length(tags)
    aux{i} = validationSet{tags(i)};
end
validationSet = aux;
nvalidation = length(validationSet);

% Reading train masks and images:
ntrain = length(trainSet);
train_image_list = cell(1, ntrain);
train_mask_list = cell(1, ntrain);
for i = 1:ntrain
    train_image_list{i} = [trainSet{i}, '.jpg'];
    train_mask_list{i} = ['\mask.', trainSet{i}, '.png'];
end

% Create validation signals vector:
count = 0;
for i = 1:length(signals)
    tag = 0;
    for j = 1:length(validationSet)
        if(~isempty(strfind(signals(i).filename, validationSet{j})))
            tag = 1;
            break
        end
    end
    if(tag == 1)
        count = count + 1;
        train_signals(count) = signals(i);
    end
end

% Reading validation masks and images:
validation_images = cell(1, nvalidation);
validation_masks = cell(1, nvalidation);
for i = 1:nvalidation
    imagefile = [dirimage, '\', validationSet{i}, '.jpg'];
    validation_images{i} = imread(imagefile);
    maskfile = [dirmask, '\mask.', validationSet{i}, '.png'];
    validation_masks{i} = imread(maskfile);
end

% Create matrices with pixels in and outside train signals:
[Xin, Xout] = create_Xin_Xout(train_signals, train_image_list, dirimage, train_mask_list, dirmask);

% Tuning parameters:
% Number of bins of histograms:
nbins_vec = [10, 15, 25, 50];
% nbins_vec = [25];
% Threshold for binarizing:
prctile_ths_vec = [70, 80, 90, 95];
% prctile_ths_vec = [70];

lgth_nbins = length(nbins_vec);
lgth_prctile_ths = length(prctile_ths_vec);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab colorspace.
colorspace = 'lab';

% Arrays of evaluation results:
precision_array = zeros(lgth_nbins, lgth_prctile_ths);
recall_array = zeros(lgth_nbins, lgth_prctile_ths);

for idx1 = 1:lgth_nbins
    nbins = nbins_vec(idx1);
    for idx2 = 1:lgth_prctile_ths
        prctile_ths = prctile_ths_vec(idx2);

        % Display progess information:
        fprintf('\n (%i/%i) nbins = %i\n (%i/%i) prctile_ths = %f\n', ...
            idx1, lgth_nbins, nbins, idx2, lgth_prctile_ths, prctile_ths)

        % Grids:
        [gridx, gridy] = histograms_create_grids(nbins, colorspace);

        % Training backprojection:
        R = backprojection_mod_train(gridx, gridy, colorspace, Xin, Xout, 0);

        % Loop over validation images:
        TPacum = 0;
        FPacum = 0;
        FNacum = 0;
        TNacum = 0;
        fprintf('\nComputing precision and recall...\n')
        progress = 10;
        fprintf('Completado 0%%\n')
        for i = 1:nvalidation
            if(i > progress / 100 * nvalidation)
                fprintf('Completado %i%%\n', progress)
                progress = progress + 10;
            end
            % Computed mask:
            computed_mask = backprojection_mod_run(validation_images{i}, R, ...
                                gridx, gridy, colorspace, prctile_ths);
            % Performance evaluation:
            [TP, FP, FN, TN] = PerformanceAccumulationPixel(computed_mask, validation_masks{i});
            TPacum = TPacum + TP;
            FPacum = FPacum + FP;
            FNacum = FNacum + FN;
            TNacum = TNacum + TN;
        end
        fprintf('Completado 100%%\n\n')

        % Computing statistics:
        % Precision:
        precision_array(idx1, idx2) = TPacum / (TPacum + FPacum);
        % Recall:
        recall_array(idx1, idx2) = TPacum / (TPacum + FNacum);
    end

end

% Storing arrays with statistics:
save('bp_mod_tuning_lab', 'precision_array', 'recall_array', 'nbins_vec', 'prctile_ths_vec');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hsv colorspace.
colorspace = 'hsv';

% Arrays of evaluation results:
precision_array = zeros(lgth_nbins, lgth_prctile_ths);
recall_array = zeros(lgth_nbins, lgth_prctile_ths);

for idx1 = 1:lgth_nbins
    nbins = nbins_vec(idx1);
    for idx2 = 1:lgth_prctile_ths
        prctile_ths = prctile_ths_vec(idx2);

        % Display progess information:
        fprintf('\n (%i/%i) nbins = %i\n (%i/%i) prctile_ths = %f\n', ...
            idx1, lgth_nbins, nbins, idx2, lgth_prctile_ths, prctile_ths)

        % Grids:
        [gridx, gridy] = histograms_create_grids(nbins, colorspace);

        % Training backprojection:
        R = backprojection_mod_train(gridx, gridy, colorspace, Xin, Xout, 0);

        % Loop over validation images:
        TPacum = 0;
        FPacum = 0;
        FNacum = 0;
        TNacum = 0;
        fprintf('\nComputing precision and recall...\n')
        progress = 10;
        fprintf('Completado 0%%\n')
        for i = 1:nvalidation
            if(i > progress / 100 * nvalidation)
                fprintf('Completado %i%%\n', progress)
                progress = progress + 10;
            end
            % Computed mask:
            computed_mask = backprojection_mod_run(validation_images{i}, R, ...
                                gridx, gridy, colorspace, prctile_ths);
            % Performance evaluation:
            [TP, FP, FN, TN] = PerformanceAccumulationPixel(computed_mask, validation_masks{i});
            TPacum = TPacum + TP;
            FPacum = FPacum + FP;
            FNacum = FNacum + FN;
            TNacum = TNacum + TN;
        end
        fprintf('Completado 100%%\n\n')

        % Computing statistics:
        % Precision:
        precision_array(idx1, idx2) = TPacum / (TPacum + FPacum);
        % Recall:
        recall_array(idx1, idx2) = TPacum / (TPacum + FNacum);
    end

end

% Storing arrays with statistics:
save('bp_mod_tuning_hsv', 'precision_array', 'recall_array', 'nbins_vec', 'prctile_ths_vec');


