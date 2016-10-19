function fhat = compute_kde2d(X, percen_data, gridx, gridy, colorspace, kernelname, h)


npixels = size(X, 1);

% Select data to compute density estimation:
if(percen_data ~= 100)
    sizereduced = round(percen_data / 100 * npixels);
    Xreduced = zeros(sizereduced, 3);
    for i = 1:sizereduced
        n = floor(rand() * npixels) + 1;
        Xreduced(i,:) = X(n,:);
    end
else
    Xreduced = X;
end

% Transform data to specified color space:
if(strcmp(colorspace, 'lab'))
    Xfinal = rgb2lab(Xreduced / 255);
    % I keep only columns 2 and 3:
    Xfinal = Xfinal(:,2:3);
elseif(strcmp(colorspace, 'hsv'))
    Xfinal = rgb2hsv(Xreduced / 255);
    % I keep only columns 1 and 2:
    Xfinal = Xfinal(:,1:2);
else
    error('Color space not recognized.')
end

fhat = kde2d(Xfinal, h, kernelname, gridx, gridy);

return

end