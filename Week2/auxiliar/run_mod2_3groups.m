function mask = run_mod2_3groups(image, params)


M_ABC = params.M_ABC;
M_DF = params.M_DF;
M_E = params.M_E;
R1_ABC = params.R1_ABC;
R1_DF = params.R1_DF;
R1_E = params.R1_E;
gridx = params.gridx;
gridy = params.gridy;
r = params.r;
threshold = params.threshold;
colorspace = params.colorspace;


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
I = I / size(Xfinal, 1);

% Computed mask ABC:
R2_ABC = min(1, M_ABC ./ I);
R_ABC = min(R1_ABC, R2_ABC);
mask_ABC = backprojection_mod2_run(image_cs, R_ABC, ...
                    gridx, gridy, colorspace, r, threshold);

% Computed mask DF:
R2_DF = min(1, M_DF ./ I);
R_DF = min(R1_DF, R2_DF);
mask_DF = backprojection_mod2_run(image_cs, R_DF, ...
                    gridx, gridy, colorspace, r, threshold);

% Computed mask E:
R2_E = min(1, M_E ./ I);
R_E = min(R1_E, R2_E);
mask_E = backprojection_mod2_run(image_cs, R_E, ...
                    gridx, gridy, colorspace, r, threshold);

% Final mask:
mask = mask_DF | mask_ABC | mask_E;

return

end