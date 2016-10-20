function R = backprojection_kde_train(signals, gridx, gridy, colorspace, ...
                                image_list, dirimage, mask_list, dirmask, ...
                                percen_data, kernelname, h)


% Create matrices with pixels in and outside signals:
[Xin, Xout] = create_Xin_Xout(signals, image_list, dirimage, mask_list, dirmask);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For signal pixels:

% Transform data to specified color space:
if(strcmp(colorspace, 'lab'))
    Xin_cs = rgb2lab(Xin / 255);
    % I keep only columns 2 and 3:
    Xin_cs = Xin_cs(:,2:3);
elseif(strcmp(colorspace, 'hsv'))
    Xin_cs = rgb2hsv(Xin / 255);
    % I keep only columns 1 and 2:
    Xin_cs = Xin_cs(:,1:2);
else
    error('Color space not recognized.')
end

% Compute density estimation of model:
M = kde2d(Xin_cs, h, kernelname, gridx, gridy, percen_data);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For non-signal pixels:

% Transform data to specified color space:
if(strcmp(colorspace, 'lab'))
    Xout_cs = rgb2lab(Xout / 255);
    % I keep only columns 2 and 3:
    Xout_cs = Xout_cs(:,2:3);
elseif(strcmp(colorspace, 'hsv'))
    Xout_cs = rgb2hsv(Xout / 255);
    % I keep only columns 1 and 2:
    Xout_cs = Xout_cs(:,1:2);
else
    error('Color space not recognized.')
end

% Compute histogram of complementary of model:
C = kde2d(Xout_cs, h, kernelname, gridx, gridy, percen_data);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ratio of model and complementary:
R = M ./ C;

return

end