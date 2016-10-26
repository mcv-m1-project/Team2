function mask = backprojection_mod2_run(image_cs, R, gridx, gridy, colorspace, ...
                                        r, threshold)

% Taking the minimum with the image:
stepx = gridx(2) - gridx(1);
stepy = gridy(2) - gridy(1);
nrow = size(image_cs, 1);
ncol = size(image_cs, 2);
bprime = zeros(nrow, ncol);
if(strcmp(colorspace, 'lab'))
    xvar = 2;
    yvar = 3;
elseif(strcmp(colorspace, 'hsv'))
    xvar = 1;
    yvar = 2;
else
    error('Color space not recognized.')
end 
for i = 1:nrow
    for j = 1:ncol
        % Find position in R for pixel (i,j) of the image:
        idxgridx = round(1 + (image_cs(i,j,xvar) - gridx(1)) / stepx);
        idxgridy = round(1 + (image_cs(i,j,yvar) - gridy(1)) / stepy);
        bprime(i,j) = R(idxgridx, idxgridy);
    end
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
b = conv2(bprime, D, 'same');

% Thresholding:
mask = b > threshold * max(b(:));

return

end