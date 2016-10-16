function week1_task3_hand_picked_masks(dirTrainDataSet, trainSet)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset
%       'trainSet' - Array of images used for training

%Read train split images
for image = 1:size(trainSet,2)
   im_orig = imread([dirTrainDataSet '\' trainSet{image} '.jpg']);
   B = double(im_orig)/255;
   B = colorspace('Lab<-RGB',B);
   
   %Red
   mask = (B(:,:,2) > 6 & B(:,:,3) > 6 | B(:,:,2) > 30) & B(:,:,1) > 10; 
   %White
   mask = mask | (B(:,:,2) < -5 & B(:,:,3) < 0 & B(:,:,1) > 75);
   %Blue
   mask = mask | (B(:,:,2) > 0 & B(:,:,3) < -4 & B(:,:,1) < 40);
    % Write masks for every image of the train set
   imwrite(mask,[dirTrainDataSet '\result_mask\hand_picked\validation\' trainSet{image} '.png']);
end

end