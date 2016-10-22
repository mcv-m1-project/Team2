function backprojection_mod_train_final(train_signals, train_image_list, dirimage, train_mask_list, dirmask)

% Load parameters:
load('bp_mod_params.mat')
colorspace = params.colorspace;
prctile_ths = params.prctile_ths;
nbins = params.nbins;

% Create matrices with pixels in and outside signals:
[Xin, Xout] = create_Xin_Xout(train_signals, train_image_list, dirimage, train_mask_list, dirmask);

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training:
R = backprojection_mod_train(gridx, gridy, colorspace, Xin, Xout, 1);

% Save result:
save('bp_mod_final.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')

return

end