function M = backprojection_sb_train(gridx, gridy, colorspace, Xin, showM)




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
% Plotting results:
if(showM == 1)
    maxM = max(max(M));
    figure()
    imshow(M, [0 maxM])
    title('Model histogram')
end

return

end