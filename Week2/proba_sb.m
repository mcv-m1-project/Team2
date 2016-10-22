%%%%%%%%%%%%%%%%%%%%%%%%%
%%% *****

clear all
close all

% Base path:
dirbase = pwd;
% Path do data set:
dirimage = [dirbase, '\..\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirimage, '\gt'];
% Path to Masks:
dirmask = [dirimage, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\..\evaluation\'])

% Load signals vector.
load('signals_workspace');

% Train / validation split:
[trainSet, validationSet] = train_validation_split(dirimage, nrepetitions);

% Creating train files lists:
ntrain = length(trainSet);
train_image_list = cell(1, ntrain);
train_mask_list = cell(1, ntrain);
for i = 1:ntrain
    train_image_list{i} = [trainSet{i}, '.jpg'];
    train_mask_list{i} = ['\mask.', trainSet{i}, '.png'];
end

% Create validation signals vector:
count = 0;
for i = 1:length(signals)
    tag = 0;
    for j = 1:length(validationSet)
        if(~isempty(strfind(signals(i).filename, validationSet{j})))
            tag = 1;
            break
        end
    end
    if(tag == 1)
        count = count + 1;
        train_signals(count) = signals(i);
    end
end

% Select parameters:
min_recall = 0.3;
params = backprojection_sb_select(min_recall)

% Training:
backprojection_sb_train_final(train_signals, train_image_list, dirimage, train_mask_list, dirmask);

% Loading parameters:
load('bp_sb_final.mat')

% Runing on random validation image:
n = floor(rand()*length(validationSet)) + 1;
imagefile = [dirimage, '\', validationSet{n}, '.jpg'];
image = imread(imagefile);
mask = backprojection_sb_run(image, M, gridx, gridy, colorspace, r, prctile_ths);
figure()
subplot(1,2,1)
imshow(image)
subplot(1,2,2)
imshow(mask, [0 1])



