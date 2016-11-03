clearvars
close all

% Load signals parameters:
load('signals_main_parameters.mat')

% Loading edge models:
load('edgesModels.mat')

% Make them all the same size, and adjusted to the mean form factor:
nrow = size(circleEdges, 1);
ncol = round(nrow * mean(form_factor));
circleEdges = imresize(circleEdges, [nrow, ncol]);
squareEdges = imresize(squareEdges, [nrow, ncol]);
upTriangleEdges = imresize(upTriangleEdges, [nrow, ncol]);
downTriangleEdges = imresize(downTriangleEdges, [nrow, ncol]);

% Save models:
save('edgesModels_resized.mat', 'circleEdges', 'squareEdges', 'upTriangleEdges', 'downTriangleEdges')