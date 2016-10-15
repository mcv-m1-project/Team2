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

week1_task3_signal_types_1D_histograms(dirTrainDataSet, trainSet, signals)

%Find masks and suitable thresholds........


%Every time an image is display it will wait for mouse click or enter to
%display the next one.
% for idx = 1:size(trainSet,2)
%     im_test = imread(['..\train\' trainSet{idx} '.jpg']);
%     im_test = double(im_test)/255;% Cast to double in the range [0,1]
%     % Change color space and plot it  
%     subplot(2,2,1);
%     image(im_test);
%     axis image
%     title Mask
%     %Change colorspace
%     B = colorspace('Lab<-RGB',im_test); 
%     %Plot every channel separately
%     % View the individual channels
%     subplot(2,2,2);
%     imagesc(B(:,:,1));
%     colormap(gray(256));
%     axis image
%     title H
%     subplot(2,2,3);
%     imagesc(B(:,:,2));
%     colormap(gray(256));
%     axis image
%     title S
%     subplot(2,2,4);
%     imagesc(B(:,:,3));
%     colormap(gray(256));
%     axis image
%     title V
%     
% %Signal type A   
% C = (B(:,:,2) >= color_signal_min_ch1 & B(:,:,2) <= color_signal_max_ch1 & B(:,:,3) >= color_signal_min_ch2 & B(:,:,3) <= color_signal_max_ch2 );
% subplot(2,2,1), imshow(C)
% 
% w = waitforbuttonpress;
% end







