%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pruebas
%%% Xi�n L�pez �lvarez

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
% R = backprojection_sb_mod_train(signals, gridx, gridy, colorspace, ...
%                     image_list, dirimage, mask_list, dirmask);
% save('bp_sb_mod_R', 'R')
load('bp_sb_mod_R.mat')

figure()
imshow(R, [min(min(R)), max(max(R))])
title('Ratio of histograms')

figure()
% Loop over images:
for i = 1:length(image_list)
    n = floor(rand() * length(image_list)) + 1;
    file = [dirimage, '\', image_list{n}];
    image = imread(file);
    b = backprojection_sb_mod_run(image, R, stepx, stepy, gridx(1), gridy(1), colorspace, r);
    title(file)
    subplot(1,2,1)
    imshow(image)
    subplot(1,2,2)
    imshow(b, [min(min(b)), max(max(b))])
    waitforbuttonpress
end


