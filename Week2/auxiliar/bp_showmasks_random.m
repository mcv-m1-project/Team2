function bp_showmasks_random(image_list, dirimage)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show the masks of the three methods on a random image


% Select random image:
n = floor(rand() * length(image_list)) + 1;
imagefile = [dirimage, '\', image_list{n}];
image = imread(imagefile);


%%%%%%
% Compute masks:

% Swain-Ballard:
load('bp_sb_final.mat')
mask_sb = backprojection_sb_run(image, M, gridx, gridy, colorspace, r, prctile_ths);

% Modified:
load('bp_mod_final.mat')
mask_mod = backprojection_mod_run(image, R, gridx, gridy, colorspace, prctile_ths);

% KDE:
load('bp_kde_final.mat')
mask_kde = backprojection_kde_run(image, R, gridx, gridy, colorspace, prctile_ths);


% Plotting results:
figure()
subplot(2,2,1)
imshow(image)
title('Original image')
subplot(2,2,2)
imshow(mask_sb, [0 1])
title('Swain-Ballard')
subplot(2,2,3)
imshow(mask_mod, [0 1])
title('Modified')
subplot(2,2,4)
imshow(mask_kde, [0 1])
title('KDE')



return

end
