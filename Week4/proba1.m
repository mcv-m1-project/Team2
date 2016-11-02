clearvars
close all

load('maskModels.mat')
figure()
subplot(2,2,1)
imshow(circleTemp, [0 1])
subplot(2,2,2)
imshow(downTriangleTemp, [0 1])
subplot(2,2,3)
imshow(squareTemp, [0 1])
subplot(2,2,4)
imshow(upTriangleTemp, [0 1])

load('grayModels.mat')
figure()
subplot(2,2,1)
imshow(circleTemp)
subplot(2,2,2)
imshow(downTriangleTemp)
subplot(2,2,3)
imshow(squareTemp)
subplot(2,2,4)
imshow(upTriangleTemp)

load('edgesModels.mat')
figure()
subplot(2,2,1)
imshow(circleEdges, [0 1])
subplot(2,2,2)
imshow(downTriangleEdges, [0 1])
subplot(2,2,3)
imshow(squareEdges, [0 1])
subplot(2,2,4)
imshow(upTriangleEdges, [0 1])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars
close all

threshold = [0.1, 0.25];
sigma = 2;

imagefile = 'C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\00.001527.jpg';
imagefile = 'C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\00.004817.jpg';
imagefile = 'C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\00.004909.jpg';
imagefile = 'C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\00.005912.jpg';
imagefile = 'C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\01.000946.jpg';
imagefile = 'C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\01.001524.jpg';

image = double(imread(imagefile));
image_bw = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3 * 255);
image_edges = edge(image_bw, 'canny', threshold, 'both', sigma);

figure()
subplot(1,2,1)
imshow(image_bw)
subplot(1,2,2)
imshow(image_edges, [0 1])



