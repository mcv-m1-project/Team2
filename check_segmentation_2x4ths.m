function check_segmentation_2x4ths(thresholds_blue, thresholds_red, image_list, dirdataset)

lowth2_blue = thresholds_blue(1);
highth2_blue = thresholds_blue(2);
lowth3_blue = thresholds_blue(3);
highth3_blue = thresholds_blue(4);

lowth2_red = thresholds_red(1);
highth2_red = thresholds_red(2);
lowth3_red = thresholds_red(3);
highth3_red = thresholds_red(4);

file = round(rand() * length(image_list)) + 1;
image = imread([dirdataset, '\', image_list{file}]);
image_lab = rgb2lab(image);
mask = image_lab(:,:,2) > lowth2_blue & image_lab(:,:,2) < highth2_blue | ...
       image_lab(:,:,2) > lowth2_red & image_lab(:,:,2) < highth2_red | ...
       image_lab(:,:,3) > lowth3_blue & image_lab(:,:,3) < highth3_blue | ...
       image_lab(:,:,3) > lowth3_red & image_lab(:,:,3) < highth3_red;
figure()
subplot(1,2,1)
imshow(image)
subplot(1,2,2)
imshow(mask, [0 1])

return

end