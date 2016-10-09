
function week1_task3_color_segmentation_test( dirTrainDataSet )
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset

% Path to Ground Truth annotations:
dirgt = [dirTrainDataSet, '\gt'];
% Path to Masks:
dirmask = [dirTrainDataSet, '\mask'];

% Create lists with the ground truth annotations files, the mask files, and
% the original image files:
[gt_list, mask_list, images_list] = create_files_list(dirTrainDataSet);

% Counting of signals types in annotations in dirgt:
[signals_list, nrepetitions] = count_signals_types(dirgt, gt_list);

% Statistics about form factor:
form_factor = analyze_form_factor(dirgt, gt_list);

% Statistics about filling ratio:
filling_ratio = analyze_filling_ratio(dirgt, gt_list, dirmask, mask_list);

% Names of signals found:
fprintf('Names of signals found:\n')
signals_list

% Times each signal appears:
fprintf('Times each signal appears:\n')
nrepetitions

[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

disp('Press Enter or Button click to display the next image:')
figure,
%Read train split images
for idx = 1:size(trainSet,2)
    im_test = imread(['..\train\' trainSet{idx} '.jpg']);
    im_test = double(im_test)/255;        % Cast to double in the range [0,1]
   
    % Lab
    subplot(2,2,1);
    image(im_test);
    axis image
    %Convert to Lab colorspace
    B = colorspace('Lab<-RGB',im_test); 
    %Plot every channel separately
    % View the individual channels
    subplot(2,2,2);
    imagesc(B(:,:,1));
    colormap(gray(256));
    axis image
    title L
    subplot(2,2,3);
    imagesc(B(:,:,2));
    colormap(gray(256));
    axis image
    title a
    subplot(2,2,4);
    imagesc(B(:,:,3));
    colormap(gray(256));
    axis image
    title b
    
%Red 
C = (B(:,:,2) > 6 & B(:,:,3) > 6 | B(:,:,2) > 30) & B(:,:,1) > 10;
% subplot(2,2,1), imshow(C)

%White
C = C | (B(:,:,2) < -5 & B(:,:,3) < 0 & B(:,:,1) > 75);
% subplot(2,2,1), imshow(C)

%Blue
C = C | (B(:,:,2) > 0 & B(:,:,3) < -4 & B(:,:,1) < 40);
subplot(2,2,1), imshow(C)

w = waitforbuttonpress;

end
end