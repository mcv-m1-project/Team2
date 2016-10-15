function mask = RBT_mask(image)




load('RBT_thresholds_blue.mat')
load('RBT_thresholds_red.mat')

% Thresholds:
lowth2_blue = thresholds_blue(1);
highth2_blue = thresholds_blue(2);
lowth3_blue = thresholds_blue(3);
highth3_blue = thresholds_blue(4);
lowth2_red = thresholds_red(1);
highth2_red = thresholds_red(2);
lowth3_red = thresholds_red(3);
highth3_red = thresholds_red(4);

% Convert image to Lab:
image_lab = rgb2lab(image);

% Compute mask:
mask = image_lab(:,:,2) > lowth2_blue & image_lab(:,:,2) < highth2_blue | ...
       image_lab(:,:,2) > lowth2_red & image_lab(:,:,2) < highth2_red | ...
       image_lab(:,:,3) > lowth3_blue & image_lab(:,:,3) < highth3_blue | ...
       image_lab(:,:,3) > lowth3_red & image_lab(:,:,3) < highth3_red;

return

end







