function week1_task3_signal_types_1D_histograms_validation(dirTrainDataSet, validationSet)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the validation dataset
%       'validationSet' - Array of images used for validation

% Initialize histograms and counters:
tic
t_ch_a = load('1D_channel_a_threshold');
t_ch_a = t_ch_a.t_ch_a;
t_ch_b = load('1D_channel_b_threshold');
t_ch_b = t_ch_b.t_ch_b;

[unused,validationSize] = size(validationSet);
for image = 1:validationSize
   im_orig = imread([dirTrainDataSet '\' validationSet{image} '.jpg']);
   im = double(im_orig)/255;
   im = colorspace('Lab<-RGB',im);
   im_ch_a = im(:,:,2);
   im_ch_b = im(:,:,3);
   
   %Normalize
   im_ch_a = im_ch_a - min(im_ch_a(:)) ;
   im_ch_a = im_ch_a / max(im_ch_a(:)) ;
   
   im_ch_b = im_ch_b - min(im_ch_b(:)) ;
   im_ch_b = im_ch_b / max(im_ch_b(:)) ;
   
   
   mask_ch_a = im2bw(im_ch_a,t_ch_a);
   mask_ch_b = im2bw(im_ch_b,t_ch_b);
   
   
   
   mask_ch_b = ~mask_ch_b; % because blue values in Lab are the lowest -b
   
   mask = mask_ch_a | mask_ch_b;
   
%    figure, subplot(2,2,1), imshow(im_orig), title('original')
%    subplot(2,2,2), imshow(mask_ch_a), title('ch_a mask')
%    subplot(2,2,3), imshow(mask_ch_b), title('ch_b mask')
%    subplot(2,2,4), imshow(mask), title('mask')
%    w = waitforbuttonpress;
   imwrite(mask,[dirTrainDataSet '\result_mask\1D_histogram\validation\' validationSet{image} '.png']);

end

toc
end