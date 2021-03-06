clearvars
close all

addpath([pwd, '\..\evaluation\'])

% Setting seed for random numbers:
rng(2000)

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
dirtrain = [pwd, '\..\..\minitrain\Circle'];
outdir = [dirtrain, '\result_masks'];

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
thresholdDT_vec = [10000, 12000, 15000, 20000, 25000];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop with different thresholds:
for i = 1:length(thresholdDT_vec)
    thresholdDT = thresholdDT_vec(i);
    fprintf('\n(%i/%i)  thresholdDT = %f\n', i, length(thresholdDT_vec), thresholdDT)
    
    % Loop over all images:
    progress = 10;
    fprintf('Completed 0%%\n')
    for idx = 1:length(imageslist)
        if(idx > progress / 100 * length(imageslist))
            fprintf('Completed %i%%\n', progress)
            progress = progress + 10;
        end

        % Reading the image and converting to double:
        filename = [dirtrain, '\', imageslist(idx).name];
        image = double(imread(filename));

        % Converting to grayscale:
        image_grey = (image(:,:,1) + image(:,:,2) + image(:,:,3)) / (3 * 255);

        % Computing edges:
        image_edges = edge(image_grey, 'canny', threshold_canny, 'both', sigma);

        % Sweep templates across image:
        windowCandidates = slidingWindow_edges_conv(image_edges, width0, height0, stepW0, stepH0, sizesrange, thresholdDT);

        % Save mat of windows candidates
        save(strcat(outdir, '\', imageslist(idx).name(1:end-4), '.mat'), 'windowCandidates');
    end
    fprintf('Completed 100%%\n')

    % Compute efficiency:
    [precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirtrain, outdir);
    fprintf('Precision: %f         Recall: %f\n', precision, recall)
    
end




