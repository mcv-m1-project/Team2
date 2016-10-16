function week1_task3_signal_types_2D_ab_histograms_validation(dirTrainDataSet, validationSet)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the validation dataset
%       'validationSet' - Array of images used for validation

tic
%Load the filter obtained on the training step
hist_acc_filtered = load('2d_ab_histograms_filter');
hist_acc_filtered = hist_acc_filtered.hist_acc_filtered;

[unused,validationSize] = size(validationSet);
for image = 1:validationSize
   im_orig = imread([dirTrainDataSet '\' validationSet{image} '.jpg']);
   %Change the colorspace to Lab
   im = double(im_orig)/255;
   im = colorspace('Lab<-RGB',im);
   [height,width,unused] = size(im);
   mask = zeros(height,width);
   [m,n,unused] = size(im);
   for i = 1:m
       for j = 1:n
           %Find the histogram bin where the pixel color is represented
           a_component = ceil((im(i,j,2)+128)/4);
           b_component = ceil((im(i,j,3)+128)/4);
           %Decide if that pixel is part of a traffic signal or not
           if hist_acc_filtered(a_component,b_component) > 0
               mask(i,j) = 1;
           end
       end
   end
%    figure,
%    subplot(1,2,1), imshow(im_orig);
%    subplot(1,2,2), imshow(mask, [0 1]);
   %Save the obtained mask
   imwrite(mask,[dirTrainDataSet '\result_mask\2d_hist\validation\' validationSet{image} '.png']);
end

toc
end