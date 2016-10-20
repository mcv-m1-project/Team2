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

% Grids:
nbins = 100;
minx = -128;
maxx = 128;
miny = -128;
maxy = 128;
stepx = (maxx - minx) / (nbins - 1);
stepy = (maxy - miny) / (nbins - 1);
gridx = minx:stepx:maxx;
gridy = miny:stepy:maxy;

% Parameters:
colorspace = 'lab';
r = 2;

% Training backprojection:
% M = backprojection_swainballard_train(signals, gridx, gridy, colorspace);
% save('bp_sb_M', 'M')
load('bp_sb_M.mat')

figure()
imshow(M, [min(min(M)), max(max(M))])
title('Model histogram')

figure()
% Loop over images:
for i = 1:length(image_list)
    n = floor(rand() * length(image_list)) + 1;
    file = [dirimage, '\', image_list{n}];
    image = imread(file);
    b = backprojection_swainballard_run(image, M, stepx, stepy, gridx, gridy, colorspace, r);
    title(file)
    subplot(1,2,1)
    imshow(image)
    subplot(1,2,2)
    imshow(b, [min(min(b)), max(max(b))])
    waitforbuttonpress
end


