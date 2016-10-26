function mask = RBT_mask(image, params)


thresholds_blue = params.thresholds_blue;
thresholds_red = params.thresholds_red;
colorspace = params.colorspace;

% Thresholds:
lowth2_blue = thresholds_blue(1);
highth2_blue = thresholds_blue(2);
lowth3_blue = thresholds_blue(3);
highth3_blue = thresholds_blue(4);
lowth2_red = thresholds_red(1);
highth2_red = thresholds_red(2);
lowth3_red = thresholds_red(3);
highth3_red = thresholds_red(4);

% Transform image to specified color space:
if(strcmp(colorspace, 'lab'))
    image_cs = rgb2lab(image);
    xvar = 2;
    yvar = 3;
elseif(strcmp(colorspace, 'hsv'))
    image_cs = rgb2hsv(image);
    xvar = 1;
    yvar = 2;
else
    error('Color space not recognized.')
end

% Compute mask:
mask = image_cs(:,:,xvar) > lowth2_blue & image_cs(:,:,xvar) < highth2_blue | ...
       image_cs(:,:,xvar) > lowth2_red & image_cs(:,:,xvar) < highth2_red | ...
       image_cs(:,:,yvar) > lowth3_blue & image_cs(:,:,yvar) < highth3_blue | ...
       image_cs(:,:,yvar) > lowth3_red & image_cs(:,:,yvar) < highth3_red;

return

end







