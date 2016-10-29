function mask = run_bp_orig(image, params)


M_ABC = params.M_ABC;
M_DF = params.M_DF;
M_E = params.M_E;
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

% Computed mask ABC:
mask_ABC = backprojection_core(image_cs, M_ABC, ...
                    gridx, gridy, colorspace, r, threshold);

% Computed mask DF:
mask_DF = backprojection_core(image_cs, M_DF, ...
                    gridx, gridy, colorspace, r, threshold);

% Computed mask E:
mask_E = backprojection_core(image_cs, M_E, ...
                    gridx, gridy, colorspace, r, threshold);

% Final mask:
mask = mask_DF | mask_ABC | mask_E;

return

end