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



[gt_list, mask_list, image_list] = ls_create_files_list(dirimage);

[Xin, Xout] = create_Xin_Xout(signals, image_list, dirimage, mask_list, dirmask);


% Grids:
nbins = 25;
minx = -64;
maxx = 64;
miny = -64;
maxy = 64;
stepx = (maxx - minx) / (nbins - 1);
stepy = (maxy - miny) / (nbins - 1);
gridx = minx:stepx:maxx;
gridy = miny:stepy:maxy;

% Parameters:
colorspace = 'lab';
h = 8;
kernelname = 'gaussian';
percen_data = 0.05;

figure()

% Density estimation for signal pixels:
fhat_in = compute_kde2d(Xin, percen_data, gridx, gridy, colorspace, kernelname, h);
subplot(2,2,1)
imshow(fhat_in, [min(min(fhat_in)) max(max(fhat_in))])
title('KDE in')

% Density estimation for non-signal pixels:
fhat_out = compute_kde2d(Xout, percen_data, gridx, gridy, colorspace, kernelname, h);
subplot(2,2,2)
imshow(fhat_out, [min(min(fhat_out)) max(max(fhat_out))])
title('KDE out')


% For histograms:
kernelname = 'naive';
h = stepx;

% Histogram for signal pixels:
H_in = compute_kde2d(Xin, percen_data, gridx, gridy, colorspace, kernelname, h);
subplot(2,2,3)
imshow(H_in, [min(min(H_in)) max(max(H_in))])
title('Histogram in')

% Histogram for signal pixels:
H_out = compute_kde2d(Xout, percen_data, gridx, gridy, colorspace, kernelname, h);
subplot(2,2,4)
imshow(H_out, [min(min(H_out)) max(max(H_out))])
title('Histogram out')




