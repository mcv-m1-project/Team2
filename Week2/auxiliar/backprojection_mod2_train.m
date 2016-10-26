function [M, R1] = backprojection_mod2_train(gridx, gridy, colorspace, Xin, Xout, showMC, showR)




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
M = M / size(Xin_cs, 1);


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

% Compute histogram of model:
C = hist3(Xout_cs, [{gridx}, {gridy}]);
C = C / size(Xout_cs, 1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ratio of histograms:
R1 = min(1, M./C);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting results:
if(showMC == 1)
    maxMC = max(max(M(:)), max(C(:)));
    figure()
    subplot(1,2,1)
    imshow(M, [0 maxMC])
    title('Model histogram')
    subplot(1,2,2)
    imshow(C, [0 maxMC])
    title('Complementary histogram')
end
% Plotting results:
if(showR == 1)
    figure()
    imshow(R1, [0 1])
    title('Ratio of histograms')
end

return

end