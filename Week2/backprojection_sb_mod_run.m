function b = backprojection_sb_mod_run(image, R, stepx, stepy, ...
                                    gridx0, gridy0, colorspace, r)


% Transform data to specified color space:
if(strcmp(colorspace, 'lab'))
    image_cs = rgb2lab(double(image) / 255);
elseif(strcmp(colorspace, 'hsv'))
    image_cs = rgb2hsv(double(image) / 255);
else
    error('Color space not recognized.')
end

% Taking the minimum with the image:
nrow = size(image_cs, 1);
ncol = size(image_cs, 2);
bprime = zeros(nrow, ncol);
if(strcmp(colorspace, 'lab'))
    for i = 1:nrow
        for j = 1:ncol
            % Find position in R for pixel (i,j) of the image:
            idxgridx = round(1 + (image_cs(i,j,2) - gridx0) / stepx);
            idxgridy = round(1 + (image_cs(i,j,3) - gridy0) / stepy);
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

return

end