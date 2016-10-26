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

% Load variables from week1_task1 to save computation time
load('signals_workspace.mat');

% Separate the train from the validation images
[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Must be run only ONCE %%%%%%%%%%%%%%%%%%%%%
ngrid = 20;
RBT_prepare(trainSet, signals, image_list, dirTrainDataSet, mask_list, dirmask, ngrid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% To fun before a loop computing the masks for every image %%%
min_percenin_blue = 50;
min_percenin_red = 40;
% This selects the thresholds that maximize the ratio and resepct the
% minimum percentage especified for pixels found in signals. Then it writes
% this thresholds to disk:
RBT_select(min_percenin_blue, min_percenin_red)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Every time an image is display it will wait for mouse click or enter to
%display the next one.
figure, 
for idx = 1:size(validationSet,2)
    im_test = imread([dirTrainDataSet '\' validationSet{idx} '.jpg']);
    image_lab = rgb2lab(im_test);
    mask = RBT_mask(im_test);
   
    subplot(1,2,1), imshow(im_test)  
    subplot(1,2,2), imshow(mask, [0 1])

    w = waitforbuttonpress;
end


