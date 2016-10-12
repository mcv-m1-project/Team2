function check_segmentation_4ths(lowth2, highth2, lowth3, highth3, image_list, dirdataset)
    
file = round(rand() * length(image_list)) + 1;
image = imread([dirdataset, '\', image_list{file}]);
image_lab = rgb2lab(image);
mask = image_lab(:,:,2) > lowth2 & image_lab(:,:,2) < highth2 | ...
       image_lab(:,:,3) > lowth3 & image_lab(:,:,3) < highth3;
figure()
subplot(1,2,1)
imshow(image)
subplot(1,2,2)
imshow(mask, [0 1])

return

end