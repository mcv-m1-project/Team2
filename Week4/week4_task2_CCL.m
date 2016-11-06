%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 2, taking the masks computed with Connected Components Labeling in
% week 3.

clearvars
close all

% Setting seed for random numbers:
% rng(1000)

% Load signals parameters:
load('signals_main_parameters.mat')

% Loading model signals (here is just to adjust the sizes):
load('grayModels.mat')
height0 = size(circleTemp, 1);
width0 = size(circleTemp, 2);
area0 = height0 * width0;

% Parameters for Canny edge detector:
threshold_canny = [0.05, 0.2];
sigma = 1;

% Train data set directory:
dirtrain = [pwd, '\..\..\train'];

% Directory with CCL masks of week 3:
dirmasks = [dirtrain, '\result_masks\CCL'];

% List of train images:
maskslist = listFiles(dirmasks);

% Threshold for accepting a window:
thresholdDT0 = 25000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try a random mask:
flag = 1;
while(flag)
    idx = floor(rand() * length(maskslist)) + 1;

    % Reading the image and converting to double:
    maskname = [dirmasks, '\', maskslist(idx).name];
    maskin = imread(maskname);
    imagename = [dirtrain, '\',  maskslist(idx).name(1:end-4), '.jpg'];
    image = double(imread(imagename));
    windowsfile = load([dirmasks, '\', maskslist(idx).name(1:end-4), '.mat']);
    windowsIn = windowsfile.windowCandidates;
    
    if(windowsIn(1).x == 0 || ...
       windowsIn(1).y == 0 || ...
       windowsIn(1).w == 0 || ...
       windowsIn(1).h == 0)
        fprintf('Empty mask. Trying again...\n')
    else
        flag = 0;
    end
end

% Converting to grayscale:
image_grey = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3 * 255);

% Part of the image in the mask:
imagein = compute_mask_edges(windowsIn, image_grey);

% Computing edges:
image_edges = edge(image_grey, 'canny', threshold_canny, 'both', sigma);
% image_edges = edge(image_grey, 'canny');

% Apply Distance Transform to image:
image_dt = bwdist(image_edges);

templates = cell(4);
windowsOut = [];

% Loop over windows from week 3:
for win = 1:length(windowsIn)
    fprintf('Checking window %i / %i... ', win, length(windowsIn))
    
    % Window coordinates:
    x = windowsIn(win).x;
    y = windowsIn(win).y;
    w = windowsIn(win).w;
    h = windowsIn(win).h;
    
    area = h * w;
    factor = area / area0;
    thresholdDT_resized = thresholdDT0 * factor;
    
    % Adjust size of models to fit the windows:
    templates{1} = imresize(circleTemp, [h, w]);
    templates{2} = imresize(squareTemp, [h, w]);
    templates{3} = imresize(upTriangleTemp, [h, w]);
    templates{4} = imresize(downTriangleTemp, [h, w]);
    
    % Compute edges from gray models:
    templates{1} = edge(templates{1}, 'canny');
    templates{2} = edge(templates{2}, 'canny');
    templates{3} = edge(templates{3}, 'canny');
    templates{4} = edge(templates{4}, 'canny');
    
    % Content of the DT image in the window:
    subIm = image_dt(y : y+h-1, x : x+w-1);

    % Score for each shape:
    scores = zeros(1,4);
    for shape = 1:4
        % Sum of product of the edge models and the Distance
        % Transform of the image:
        scores(shape) = sum(sum(templates{shape} .* subIm));
    end
    minscore = min(scores);
    
    % Deciding if the window is accepted:
    if(minscore < thresholdDT_resized)
        windowsOut = [windowsOut, struct('x', x, 'y', y, 'w', w, 'h', h)];
        fprintf('Accepted.\n')
    else
        fprintf('Rejected.\n')
    end
end

% Part of the image in the mask:
imageout = compute_mask_edges(windowsOut, image_grey);

figure()
subplot(2,2,1)
imshow(image_grey)
subplot(2,2,2)
imshow(imagein)
subplot(2,2,3)
imshow(imageout)



