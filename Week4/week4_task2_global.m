clearvars
close all

% Parameters for Canny edge detector:
threshold = [0.1, 0.25];
sigma = 2;

% Train data set directory:
dirtrain = [pwd, '\..\..\train'];

% List of train images:
imageslist = listFiles(dirtrain);

for file = imageslist
    % Reading the image and converting to double:
    image = double(imread(dirtrain, '\', file));
    
    % Converting to grayscale:
    image_grey = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3 * 255);
    
    % Computing edges:
    image_edges = edge(image_grey, 'canny', threshold, 'both', sigma);
    
    % Sweep templates across image:
    [mask, windowCandidates] = slidingWindow_edges(image_edges, width, height, stepW, stepH, sizes);
end






