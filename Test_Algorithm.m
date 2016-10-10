%clear all
%close all
% We add the path where some scripts are.
addpath('evaluation\')
addpath('colorspace\')
addpath('..\train\')

% Base directory:
dirbase = pwd;
% Path to the training dataset images
dirTrainDataSet = [dirbase, '\..\train'];

%Every time an image is display it will wait for mouse click or enter to
%display the next one.

%week1_task3_color_segmentation_test( dirTrainDataSet );

week1_task3_color_segmentation_equalization_test( dirTrainDataSet );







