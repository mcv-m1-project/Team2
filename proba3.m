
% Grids:
nbins = 25;
minx = -128;
maxx = 128;
miny = -128;
maxy = 128;
stepx = (maxx - minx) / (nbins - 1);
stepy = (maxy - miny) / (nbins - 1);
gridx = minx:stepx:maxx;
gridy = miny:stepy:maxy;

% Parameters:
colorspace = 'lab';
percen_data = 0.05;
kernelname = 'naive';
h = stepx;

figure()

% MATLAB HISTOGRAMS:

npixels = size(Xin, 1);

% Select data to compute density estimation:
if(percen_data ~= 100)
    sizereduced = round(percen_data / 100 * npixels);
    Xreduced = zeros(sizereduced, 3);
    for i = 1:sizereduced
        n = floor(rand() * npixels) + 1;
        Xreduced(i,:) = Xin(n,:);
    end
else
    Xreduced = Xin;
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

% Density estimation for signal pixels:
fhat_in = hist3(Xfinal, [{gridx}, {gridy}]);
fhat_in = fhat_in / (sizereduced * h);
subplot(2,2,1)
imshow(fhat_in, [min(min(fhat_in)) max(max(fhat_in))])
title('KDE in')

% Histogram for signal pixels:
H_in = kde2d(Xfinal, h, 'naive', gridx, gridy);
subplot(2,2,2)
imshow(H_in, [min(min(H_in)) max(max(H_in))])
title('Histogram in')

%%%%%%%%%%%%%%
% Density estimation for non-signal pixels:

npixels = size(Xout, 1);

% Select data to compute density estimation:
if(percen_data ~= 100)
    sizereduced = round(percen_data / 100 * npixels);
    Xreduced = zeros(sizereduced, 3);
    for i = 1:sizereduced
        n = floor(rand() * npixels) + 1;
        Xreduced(i,:) = Xout(n,:);
    end
else
    Xreduced = Xout;
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
fhat_out = hist3(Xfinal, [{gridx}, {gridy}]);
fhat_out = fhat_out / (sizereduced * h);
subplot(2,2,3)
imshow(fhat_out, [min(min(fhat_out)) max(max(fhat_out))])
title('KDE out')

% Histogram for signal pixels:
H_out = kde2d(Xfinal, h, 'naive', gridx, gridy);
subplot(2,2,4)
imshow(H_out, [min(min(H_out)) max(max(H_out))])
title('Histogram out')

difin = fhat_in - H_in;
max(max(difin))

difout = fhat_out - H_out;
max(max(difout))
