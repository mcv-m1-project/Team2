function R = backprojection_sb_mod_train(signals, gridx, gridy, colorspace, ...
                                image_list, dirimage, mask_list, dirmask)


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

% Compute histogram of model:
M = hist3(Xin_cs, [{gridx}, {gridy}]);


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
C = hist3(Xout_cs, [{gridx}, {gridy}]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ratio of model and complementary:
R = M ./ C;

return

end