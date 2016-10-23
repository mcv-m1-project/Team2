function backprojection_kde_train_final(train_signals, train_image_list, dirimage, train_mask_list, dirmask)

% Load parameters:
load('bp_kde_select.mat')
h = params.h;
colorspace = params.colorspace;
prctile_ths = params.prctile_ths;
nbins = 50;

% Fixed parameters:
percen_data = 2;
kernelname = 'gaussian';

% Create matrices with pixels in and outside signals:
[Xin, Xout] = create_Xin_Xout(train_signals, train_image_list, dirimage, train_mask_list, dirmask);

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training:
R = backprojection_kde_train(gridx, gridy, colorspace, percen_data, kernelname, h, Xin, Xout, 1);

% Save result:
save('bp_kde_final.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')

return

end