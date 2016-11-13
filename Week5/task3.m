%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% All methods in one system.

clearvars
close all

% Load data:
load('red_hist_32.mat')
load('blue_hist_32.mat')
load('rb_hist_32.mat')
load('signals_main_parameters.mat')
load('signals_size.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Parameters:

% Color segmentation:
params.cs.th = 0.004;
params.cs.bins = 32;
params.cs.red_hist = red_hist;
params.cs.blue_hist = blue_hist;
params.cs.rb_hist = rb_hist;

% Morphological operators:
params.mo.signals_size = signals_size;

% Connected components:
params.cc.min_fr = min(filling_ratio);
params.cc.max_fr = max(filling_ratio);
params.cc.min_ff = min(form_factor);
params.cc.max_ff = max(form_factor);
params.cc.minimum_size = min(min_size);
params.cc.maximum_size = max(max_size);

% Hough detection:
params.hd.threshold_canny = [0.05, 0.2];
params.hd.sigma = 1;
params.hd.grdthres = 1.5;
params.hd.fltr4LM_R = 23;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Paths:
addpath('..\')
addpath('..\evaluation\')
addpath('..\circular_hough\')

% Directories:
% dirTestImages = [pwd, '\..\..\train'];
dirTestImages = [pwd, '\..\..\minitrain'];
% dirTestImages = [pwd, '\..\..\validation'];
outputDir = [dirTestImages, '\result_masks\week5_task3'];

% Check for existence of output directory:
if(7 ~= exist(outputDir, 'dir'))
    mkdir(outputDir);
end

% List files:
files = ListFiles(dirTestImages);
nFiles = length(files);

% Loop over all images:
fprintf('\nSignal detection system...\n')
progress = 10;
fprintf('Completed 0%%\n')
for i = 1:nFiles
    if(i > progress / 100 * nFiles)
        fprintf('Completed %i%%\n', progress)
        progress = progress + 10;
    end
    
    % Read image:
    fileId = files(i).name(1:9);
    image = imread([dirTestImages, '\', files(i).name]);

    % Apply the whole system to the given image:
    [mask, windowCandidates] = task3_system(image, params);
    
    % Write the result:
    imwrite(mask, [outputDir, '\', fileId, '.png']);
%     save([outputDir, '\', fileId, '.mat'], 'windowCandidates');
end
fprintf('Completed 100%%\n')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Evaluation:
% region_based_evaluation(dirTestImages, outputDir);
pixel_based_evaluation(dirTestImages, outputDir);









