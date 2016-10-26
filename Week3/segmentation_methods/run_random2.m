function run_random2(imageset, dirimage, runfun1, params1, runfun2, params2)



n = floor(rand() * length(imageset)) + 1;
imagefile = [dirimage, '\', imageset{n}, '.jpg'];
image = imread(imagefile);

mask1 = runfun1(image, params1);

mask2 = runfun2(image, params2);

figure()
subplot(2,2,1)
imshow(image)
title(imageset{n})
subplot(2,2,2)
imshow(mask1, [0 1])
title('mask1')
subplot(2,2,3)
imshow(mask2, [0 1])
title('mask2')


return

end