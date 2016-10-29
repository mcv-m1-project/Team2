function M = train_bp_orig_group(signals, gridx, gridy, colorspace)




% Initialize model histogram:
M = zeros(length(gridx), length(gridy));
npixels_acum = 0;

% Loop over signals:
for signal = 1:length(signals)
    image = signals(signal).image;
    
    % Transform image to specified color space:
    if(strcmp(colorspace, 'lab'))
        image_cs = rgb2lab(double(image) / 255);
    elseif(strcmp(colorspace, 'hsv'))
        image_cs = rgb2hsv(double(image) / 255);
    else
        error('Color space not recognized.')
    end
    
    % Create matrix with pixels of image:
    npixels = size(image_cs, 1) * size(image_cs, 2);
    Ximage = zeros(npixels, 3);
    idx = 0;
    for i = 1:size(image_cs, 1)
        for j = 1:size(image_cs, 2)
            idx = idx + 1;
            Ximage(idx,:) = image_cs(i, j, :);
        end
    end

    % Depending on color space, take some columns or others:
    if(strcmp(colorspace, 'lab'))
        Xfinal = Ximage(:,2:3);
    elseif(strcmp(colorspace, 'hsv'))
        Xfinal = Ximage(:,1:2);
    else
        error('Color space not recognized.')
    end

    % Compute histogram of input image:
    I = hist3(Xfinal, [{gridx}, {gridy}]);
    
    % Accumulated histogram:
    M = M + I;
    npixels_acum = npixels_acum + size(Xfinal,1);
end

% Normalizing model histogram:
M = M / npixels_acum;

return

end