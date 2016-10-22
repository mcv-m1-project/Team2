function R = backprojection_kde_train(gridx, gridy, colorspace, ...
                                percen_data, kernelname, h, Xin, Xout, showMCR)




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
R = min(1, M ./ C);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting results:
if(showMCR == 1)
    maxMC = max(max(max(M)), max(max(C)));
    figure()
    subplot(2,2,1)
    imshow(M, [0 maxMC])
    title('M')
    subplot(2,2,2)
    imshow(C, [0 maxMC])
    title('C')
    subplot(2,2,3)
    imshow(R, [0 1])
    title('R')
end


return

end