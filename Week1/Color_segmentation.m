clear all
close all
% We add the path where some scripts are.
addpath('..\evaluation\')
addpath('..\colorspace\')
addpath('..\..\test\')

% Base directory:
dirbase = pwd;
% Path to the test dataset images
dirTestDataSet = [dirbase, '\..\..\test'];

% Path to the computed masks:
mkdir([dirTestDataSet, '\result_masks']);
dir_result_masks = [dirTestDataSet, '\result_masks'];

%Load variables from week1_task1 to save computation time
load('signals_workspace.mat');

%Load the threshold needed in the 2D joint histogram method
hist_acc_filtered = load('2d_ab_histograms_filter');

%Compute the masks for the test images
test_images = dir(dirTestDataSet);
tic
hist_acc_filtered = hist_acc_filtered.hist_acc_filtered;
for idx = 3:size(test_images,1)-1
   im_orig = imread([dirTestDataSet '\' test_images(idx).name]);
   im = double(im_orig)/255;
   im = colorspace('Lab<-RGB',im);
   [height,width,unused] = size(im);
    mask = zeros(height,width);
   [m,n,unused] = size(im);
   for i = 1:m
       for j = 1:n
           a_component = ceil((im(i,j,2)+128)/4);
           b_component = ceil((im(i,j,3)+128)/4);
           if hist_acc_filtered(a_component,b_component) > 0
               mask(i,j) = 1;
           end
       end
   end
   file_name = strsplit(test_images(idx).name,'.jpg');
   imwrite(mask,[dirTestDataSet '\result_masks\mask.' char(file_name(1)) '.png']);
end

toc
