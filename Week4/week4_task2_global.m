clearvars
close all

% Computing Distance Transforms of model signals:
load('edgesModels.mat')
circleDT = bwdist(circleEdges);
squareDT = bwdist(squareEdges);
upTriangleDT = bwdist(upTriangleEdges);
downTriangleDT = bwdist(downTriangleEdges);
save('DTModels.mat', 'circleDT', 'squareDT', 'upTriangleDT', 'downTriangleDT')
figure()
subplot(2,4,1)
imshow(circleEdges)
subplot(2,4,2)
imshow(circleDT, [0, max(max(circleDT))])
subplot(2,4,3)
imshow(squareEdges)
subplot(2,4,4)
imshow(squareDT, [0, max(max(squareDT))])
subplot(2,4,5)
imshow(upTriangleEdges)
subplot(2,4,6)
imshow(upTriangleDT, [0, max(max(upTriangleDT))])
subplot(2,4,7)
imshow(downTriangleEdges)
subplot(2,4,8)
imshow(downTriangleDT, [0, max(max(downTriangleDT))])

% Parameters for Canny edge detector:
threshold = [0.1, 0.25];
sigma = 2;

% Train data set directory:
dirtrain = [pwd, '\..\..\train'];

% List of train images:
imageslist = listFiles(dirtrain);

for i = 1 : size(imageslist,1)
    % Reading the image and converting to double:
    file=strcat(dirtrain, '\', imageslist(i).name);
    image = double(imread(file));
    
    % Converting to grayscale:
    image_grey = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3 * 255);
    
    % Computing edges:
    image_edges = edge(image_grey, 'canny', threshold, 'both', sigma);
    
    % Sweep templates across image:
    [mask, windowCandidates] = slidingWindow_edges(image_edges, width, height, stepW, stepH, sizes);
end






