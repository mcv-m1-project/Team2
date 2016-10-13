clear all
close all
% We add the path where some scripts are.
addpath('evaluation\')
addpath('colorspace\')
addpath('..\train\')

% Base directory:
dirbase = pwd;
% Path to the training dataset images
dirTrainDataSet = [dirbase, '\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirTrainDataSet, '\gt'];
% Path to Masks:
dirmask = [dirTrainDataSet, '\mask'];

%Load variables from week1_task1 to save computation time
load('signals_workspace.mat');

%Separate the train from the validation images
[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

%Call the function to build and save the 2D histograms for each signal type
%using Lab color space
%week1_task3_signal_types_2D_ab_histograms(dirTrainDataSet, trainSet, signals)
  
%Find masks and suitable thresholds........







load('red_blue_thresholds.mat')

% Check on the validation split images:
lowth2_blue = thresholds_blue(1);
highth2_blue = thresholds_blue(2);
lowth3_blue = thresholds_blue(3);
highth3_blue = thresholds_blue(4);
lowth2_red = thresholds_red(1);
highth2_red = thresholds_red(2);
lowth3_red = thresholds_red(3);
highth3_red = thresholds_red(4);

%Every time an image is display it will wait for mouse click or enter to
%display the next one.
figure, 
for idx = 1:size(validationSet,2)
    im_test = imread([dirTrainDataSet '\' validationSet{idx} '.jpg']);
    image_lab = rgb2lab(im_test);
    mask = image_lab(:,:,2) > lowth2_blue & image_lab(:,:,2) < highth2_blue | ...
       image_lab(:,:,2) > lowth2_red & image_lab(:,:,2) < highth2_red | ...
       image_lab(:,:,3) > lowth3_blue & image_lab(:,:,3) < highth3_blue | ...
       image_lab(:,:,3) > lowth3_red & image_lab(:,:,3) < highth3_red;
   
    subplot(1,2,1), imshow(im_test)  
    subplot(1,2,2), imshow(mask, [0 1])

    w = waitforbuttonpress;
end







