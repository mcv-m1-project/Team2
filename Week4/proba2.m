clearvars
close all


% Load signals parameters:
load('signals_main_parameters.mat')

% Loading model signals:
load('grayModels.mat')

% Sizes to try:
sidefactors = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
height0 = 10;
width0 = 10;
nsizes = 3;
minimum_area = min(min_size);
maximum_area = max(max_size);
minsize = minimum_area / (height0 * width0);
maxsize = maximum_area / (height0 * width0);
sizesrange = minsize : (maxsize - minsize) / (nsizes - 1) : maxsize;

% Initialize scores of each model ans size:
scoreCircle = zeros(1, length(sidefactors));
scoreSquare = zeros(1, length(sidefactors));
scoreDownTriangle = zeros(1, length(sidefactors));
scoreUpTriangle = zeros(1, length(sidefactors));

for i = 1:length(sidefactors)
    factor = sidefactors(i);
    
    % Current sides:
    height = factor * height0;
    width = factor * width0;
    
    % Fake window widh a vertical edge in the middle:
    window = zeros(height, width);
    window(:, floor(width / 2)) = 1;
    
    % Distance transform of the fake window:
    windowDT = bwdist(window);
    
    % Resizing:
    circleTemp_res = imresize(circleTemp, [height, width]);
    squareTemp_res = imresize(squareTemp, [height, width]);
    downTriangleTemp_res = imresize(downTriangleTemp, [height, width]);
    upTriangleTemp_res = imresize(upTriangleTemp, [height, width]);
    
    % Computing edges:
    circleEdges = edge(circleTemp_res, 'canny');
    squareEdges = edge(squareTemp_res, 'canny');
    downTriangleEdges = edge(downTriangleTemp_res, 'canny');
    upTriangleEdges = edge(upTriangleTemp_res, 'canny');
    
    % Score for each model:
    scoreCircle(i) = sum(sum(windowDT .* circleEdges));
    scoreSquare(i) = sum(sum(windowDT .* squareEdges));
    scoreDownTriangle(i) = sum(sum(windowDT .* downTriangleEdges));
    scoreUpTriangle(i) = sum(sum(windowDT .* upTriangleEdges));
end

[scoreCircle', scoreSquare', scoreDownTriangle', scoreUpTriangle']





