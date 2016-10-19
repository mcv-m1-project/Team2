function M = backprojection_swainballard_train(signals, gridx, gridy, colorspace)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For signal pixels:

% Create matrix with pixels of signals:
Xin = [];
nsignals = length(signals);
for count = 1:nsignals
    Xsignal = zeros(size(signals(count).image, 1) * size(signals(count).image, 2), 3);
    idx = 0;
    for i = 1:size(signals(count).image, 1)
        for j = 1:size(signals(count).image, 2)
            idx = idx + 1;
            Xsignal(idx,:) = signals(count).image(i, j, :);
        end
    end
    Xin = [Xin; Xsignal];
end
npixels = size(Xin, 1);

% Transform data to specified color space:
if(strcmp(colorspace, 'lab'))
    Xfinal = rgb2lab(Xin / 255);
    % I keep only columns 2 and 3:
    Xfinal = Xfinal(:,2:3);
elseif(strcmp(colorspace, 'hsv'))
    Xfinal = rgb2hsv(Xin / 255);
    % I keep only columns 1 and 2:
    Xfinal = Xfinal(:,1:2);
else
    error('Color space not recognized.')
end

% Compute histogram of model:
M = hist3(Xfinal, [{gridx}, {gridy}]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For non-signal pixels:

% Create matrix with pixels of signals:
Xin = [];
nsignals = length(signals);
for count = 1:nsignals
    Xsignal = zeros(size(signals(count).image, 1) * size(signals(count).image, 2), 3);
    idx = 0;
    for i = 1:size(signals(count).image, 1)
        for j = 1:size(signals(count).image, 2)
            idx = idx + 1;
            Xsignal(idx,:) = signals(count).image(i, j, :);
        end
    end
    Xin = [Xin; Xsignal];
end
npixels = size(Xin, 1);

% Transform data to specified color space:
if(strcmp(colorspace, 'lab'))
    Xfinal = rgb2lab(Xin / 255);
    % I keep only columns 2 and 3:
    Xfinal = Xfinal(:,2:3);
elseif(strcmp(colorspace, 'hsv'))
    Xfinal = rgb2hsv(Xin / 255);
    % I keep only columns 1 and 2:
    Xfinal = Xfinal(:,1:2);
else
    error('Color space not recognized.')
end

% Compute histogram of model:
M = hist3(Xfinal, [{gridx}, {gridy}]);

return

end