clearvars
close all

% Load signals parameters:
load('signals_main_parameters.mat')

% Loading model signals (here is just to adjust the sizes):
load('grayModels.mat')
% height0 = size(circleTemp, 1);
% width0 = size(circleTemp, 2);

% Parameters for Canny edge detector:
threshold_canny = [0.05, 0.2];
sigma = 1;

% Train data set directory:
dirtrain = [pwd, '\..\..\test'];
outdir = [dirtrain, '\result_masks\chamfer'];

% List of train images:
imageslist = listFiles(dirtrain);

% Size of windows:
load('interpolated_thresholds');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop with different thresholds:


for idx = 1:length(imageslist)
    % Reading the image and converting to double:
    filename = [dirtrain, '\', imageslist(idx).name];
    image = imread(filename);
    
    % Converting to grayscale:
    image_grey = rgb2gray(image);
    % Computing edges:
    image_edges = edge(image_grey, 'canny', threshold_canny, 'both', sigma);
    
    % Apply Distance Transform to image:
    image_dt = bwdist(image_edges);
    
    % Sweep templates across image:
    windowCandidates = slidingWindow_edges2(image_dt, windows_width, windows_height, interpolated_thresholds);
    
    % Save mat of windows candidates
    save(strcat(outdir, '\', imageslist(idx).name(1:end-4), '.mat'), 'windowCandidates');
    
    
    mask = compute_mask_edges(windowCandidates,image_grey);
    imwrite(mask,strcat(outdir, '\', imageslist(idx).name(1:end-4), '.png'));
%     imwrite(uint8(image_dt),strcat(outdir, '\image_dt.', imageslist(idx).name(1:end-4), '.png'));
    
end


% % Compute efficiency:
% [precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirtrain, outdir);
% save('interpolated_threshold_evaluation.mat', 'precision', 'recall','F1', 'TP', 'FN', 'FP');
% fprintf('Precision: %f         Recall: %f\n', precision, recall);