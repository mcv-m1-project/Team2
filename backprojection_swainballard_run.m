function b = backprojection_swainballard_run(image, M, stepx, stepy, gridx, gridy, colorspace, r)


% Transform data to specified color space:
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

% Ratio of histograms:
R = M ./ I;

% Taking the minimum with the image:
nrow = size(image_cs, 1);
ncol = size(image_cs, 2);
bprime = zeros(nrow, ncol);
if(strcmp(colorspace, 'lab'))
    for i = 1:nrow
        for j = 1:ncol
            % Find position in R for pixel (i,j) of the image:
            idxgridx = round(1 + (image_cs(i,j,2) - gridx(1)) / stepx);
            idxgridy = round(1 + (image_cs(i,j,3) - gridy(1)) / stepy);
            bprime(i,j) = min(R(idxgridx, idxgridy), 1);
        end
    end
    
else
    error('PART INCOMPLETE')
end

% We definde the disk of radius r:
D = zeros(2*r+1, 2*r+1);
for i = 1:(2*r+1)
    for j = 1:(2*r+1)
        if((i-r-1)^2 + (j-r-1)^2 <= r^2)
            D(i,j) = 1;
        end
    end
end

% Convolution:
b = conv2(bprime, D);

figure()
subplot(1,2,1)
imshow(I, [min(min(I)), max(max(I))])
title('I')
subplot(1,2,2)
imshow(b, [min(min(b)), max(max(b))])
title('b')

return

end