%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 2, with sliding windows. Distance Transform is computed for every
% window, and is the only criterium to accept or reject them.

clearvars
close all

% Setting seed for random numbers:
rng(1000)

% Load signals parameters:
load('signals_main_parameters.mat')

% Loading model signals (here is just to adjust the sizes):
load('grayModels.mat')
height0 = size(circleTemp, 1);
width0 = size(circleTemp, 2);

% Parameters for Canny edge detector:
threshold_canny = [0.05, 0.2];
sigma = 1;

% Train data set directory:
dirtrain = [pwd, '\..\..\train'];

% List of train images:
imageslist = listFiles(dirtrain);

% Size of windows:
nsizes = 3;
minimum_area = min(min_size);
maximum_area = max(max_size);
minsize = (minimum_area + (maximum_area - minimum_area) / 4) / (height0 * width0);
maxsize = maximum_area * 1.1 / (height0 * width0);
sizesrange = minsize : (maxsize - minsize) / (nsizes - 1) : maxsize;

% Step between windows:
stepH0 = height0 * 0.05;
stepW0 = width0 * 0.05;

% Threshold for accepting a window:
thresholdDT = 10000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try a random image:
idx = floor(rand() * length(imageslist)) + 1;

% Reading the image and converting to double:
filename = [dirtrain, '\', imageslist(idx).name];
image = double(imread(filename));

% Converting to grayscale:
image_grey = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3 * 255);

% Computing edges:
image_edges = edge(image_grey, 'canny', threshold_canny, 'both', sigma);
% image_edges = edge(image_grey, 'canny');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

% Sweep templates across image:
windowCandidates = slidingWindow_edges_conv(image_edges, width0, height0, stepW0, stepH0, sizesrange, thresholdDT);

% Compute mask:
mask2 = compute_mask_edges(windowCandidates, image_grey);

% Show results:
figure()
subplot(2,2,1)
imshow(image_grey)
subplot(2,2,2)
imshow(image_edges)
subplot(2,2,3)
imshow(mask2)

time = toc;
fprintf('Time for convolution: %f\n', time)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic
% 
% % Sweep templates across image:
% windowCandidates = slidingWindow_edges(image_edges, width0, height0, stepW0, stepH0, sizesrange, thresholdDT);
% 
% % Compute mask:
% mask1 = compute_mask_edges(windowCandidates, image_grey);
% 
% % Show results:
% figure()
% subplot(2,2,1)
% imshow(image_grey)
% subplot(2,2,2)
% imshow(image_edges)
% subplot(2,2,3)
% imshow(mask1)
% 
% time = toc;
% fprintf('Time for loops: %f\n', time)





