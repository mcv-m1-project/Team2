function backprojection_sb_train_final(train_signals, train_image_list, dirimage, train_mask_list, dirmask)

% Load parameters:
load('bp_sb_select.mat')
colorspace = params.colorspace;
prctile_ths = params.prctile_ths;
nbins = params.nbins;
% r = params.r;
r=5;

% Create matrices with pixels in and outside signals:
[Xin, ~] = create_Xin_Xout(train_signals, train_image_list, dirimage, train_mask_list, dirmask);

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Training:
M = backprojection_sb_train(gridx, gridy, colorspace, Xin, 1);

% Save result:
save('bp_sb_final.mat', 'M', 'gridx', 'gridy', 'colorspace', 'prctile_ths', 'r')

return

end