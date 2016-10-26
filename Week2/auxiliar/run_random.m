function run_random(imageset, dirimage, runfun, params)



n = floor(rand() * length(imageset)) + 1;
imagefile = [dirimage, '\', imageset{n}, '.jpg'];
image = imread(imagefile);

mask = runfun(image, params);

figure()
subplot(1,2,1)
imshow(image)
title(imageset{n})
subplot(1,2,2)
imshow(mask, [0 1])
title('mask')


return

end