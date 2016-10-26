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
[trainC, trainF, trainother] = separate_list_groups_CF(trainSet, signals);
[validationC, validationF, validationother] = separate_list_groups_CF(validationSet, signals);

% Create train and validation signals vectors for each group:
% ABC:
[signals_C_train, signals_C_validation] = separate_signals_train(trainC, validationC, signals);
% DF:
[signals_F_train, signals_F_validation] = separate_signals_train(trainF, validationF, signals);
% E:
[signals_other_train, signals_other_validation] = separate_signals_train(trainother, validationother, signals);

% Parameters:
r = 2;
nbins = 100;
threshold = 0.999999;
colorspace = 'lab';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  C  training

% Create matrices with pixels in and outside train signals:
[Xin, Xout] = create_Xin_Xout(signals_C_train, trainC, dirimage, dirmask);

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training backprojection:
[MC, R1C] = backprojection_mod2_train(gridx, gridy, colorspace, Xin, Xout, 0, 0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  F  training

% Create matrices with pixels in and outside train signals:
[Xin, Xout] = create_Xin_Xout(signals_F_train, trainF, dirimage, dirmask);

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training backprojection:
[MF, R1F] = backprojection_mod2_train(gridx, gridy, colorspace, Xin, Xout, 0, 0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  running

file = 10;
imagefile = [dirimage, '\', validationSet{file}, '.jpg'];
image = imread(imagefile);

% Computed mask C:
mask_C = backprojection_mod2_run(image, MC, R1C, ...
                    gridx, gridy, colorspace, r, threshold, 0);
                
% Computed mask F:
mask_F = backprojection_mod2_run(image, MF, R1F, ...
                    gridx, gridy, colorspace, r, threshold, 0);
                
% Final mask:
final_mask = mask_F | mask_C;

% Show result:
figure()
subplot(2,2,1)
imshow(image)
title('Original image')
subplot(2,2,2)
imshow(mask_C, [0 1])
title('mask C')
subplot(2,2,3)
imshow(mask_F, [0 1])
title('mask F')
subplot(2,2,4)
imshow(final_mask, [0 1])
title('Final mask')




