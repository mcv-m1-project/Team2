%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pruebas
%%% Xián López Álvarez

clear all
close all

% Base path:
dirbase = pwd;
% Path do data set:
dirimage = [dirbase, '\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirimage, '\gt'];
% Path to Masks:
dirmask = [dirimage, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\evaluation\'])

% Load signals vector.
load('signals_workspace');

% Files lists:
[gt_list, mask_list, image_list] = ls_create_files_list(dirimage);

% Parameters:
colorspace = 'lab';
r = 2;

% Grids:
nbins = 100;
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training backprojection:
% percen_data = 0.01;
% kernelname = 'gaussian';
% h = 8;
% R = backprojection_kde_train(signals, gridx, gridy, colorspace, ...
%                     image_list, dirimage, mask_list, dirmask, ...
%                     percen_data, kernelname, h);
% save('bp_kde_R', 'R')
load('bp_kde_R.mat')

figure()
imshow(R, [min(min(R)), max(max(R))])
title('Ratio of histograms')

figure()
% Loop over images:
for i = 1:length(image_list)
    n = floor(rand() * length(image_list)) + 1;
    file = [dirimage, '\', image_list{n}];
    image = imread(file);
    b = backprojection_kde_run(image, R, gridx, gridy, colorspace, r);
    title(file)
    subplot(1,2,1)
    imshow(image)
    subplot(1,2,2)
    imshow(b, [min(min(b)), max(max(b))])
    waitforbuttonpress
end


