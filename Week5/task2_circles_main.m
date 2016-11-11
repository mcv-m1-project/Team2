clearvars
close all

% Paths:
addpath('..\')
addpath('..\evaluation')
addpath([pwd, '\..\circular_hough\'])

% Directories:
% dirTestImages = [pwd, '\..\..\train'];
dirTestImages = [pwd, '\..\..\validation'];
inputWindowsDir = [dirTestImages, '\result_masks\CC'];
outputDir = [dirTestImages, '\result_masks\week5_task2_hough_circles'];

% Parameters:
grdthres = 3;
fltr4LM_R = 15;
resize = 1;

% Run circles search:
tic
task2_circles(dirTestImages, inputWindowsDir, outputDir, grdthres, fltr4LM_R, resize)
totalTime = toc;

files = ListFiles(dirTestImages);
nFiles = length(files);
timePerFrame = totalTime / nFiles;
fprintf('Total time: %f\n Time per frame: %f\n', totalTime, timePerFrame);

% Evaluate:
[precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirTestImages, outputDir);



