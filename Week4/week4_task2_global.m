clearvars
close all

% Load signals parameters:
load('signals_main_parameters.mat')

% Computing Distance Transforms of model signals:
load('edgesModels.mat')
circleDT = circleEdges;
squareDT = squareEdges;
upTriangleDT = upTriangleEdges;
downTriangleDT = downTriangleEdges;
% Make them all the same size, and adjusted to the mean form factor:
nrowDT = size(circleDT, 1);
ncolDT = round(nrowDT * mean(form_factor));
circleDT = imresize(circleDT, [nrowDT, ncolDT]);
squareDT = imresize(squareDT, [nrowDT, ncolDT]);
upTriangleDT = imresize(upTriangleDT, [nrowDT, ncolDT]);
downTriangleDT = imresize(downTriangleDT, [nrowDT, ncolDT]);
% Save models:
save('DTModels.mat', 'circleDT', 'squareDT', 'upTriangleDT', 'downTriangleDT')

% Parameters for Canny edge detector:
threshold = [0.1, 0.25];
sigma = 2;

% Train data set directory:
dirtrain = [pwd, '\..\..\train'];

% List of train images:
imageslist = listFiles(dirtrain);

% Size of windows:
nsizes = 10;
minimum_area = min(min_size);
maximum_area = max(max_size);
minsize = minimum_area / (nrowDT * ncolDT);
maxsize = maximum_area / (nrowDT * ncolDT);
sizesrange = minsize : (maxsize - minsize) / (nsizes - 1) : maxsize;
height0 = nrowDT;
width0 = ncolDT;

% Step between windows:
stepH0 = height0 * 0.1;
stepW0 = width0 * 0.1;

% Threshold:
thresholdDT = 10;

% Loop over images:
for idx = 1:length(imageslist)
    % Reading the image and converting to double:
    filename = [dirtrain, '\', imageslist(idx).name];
    image = double(imread(filename));
    
    % Converting to grayscale:
    image_grey = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3 * 255);
    
    % Computing edges:
    image_edges = edge(image_grey, 'canny', threshold, 'both', sigma);
    
    % Sweep templates across image:
%     [mask, windowCandidates] = slidingWindow_edges(image_edges, width0, height0, stepW0, stepH0, sizesrange, thresholdDT);
    windowCandidates = slidingWindow_edges(image_edges, width0, height0, stepW0, stepH0, sizesrange, thresholdDT);
end






