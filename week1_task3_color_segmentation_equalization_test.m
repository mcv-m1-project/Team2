function week1_task3_color_segmentation_equalization_test( dirTrainDataSet )
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

% Names of signals found:
fprintf('Names of signals found:\n')
signals_list

% Times each signal appears:
fprintf('Times each signal appears:\n')
nrepetitions

[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

%create a max and a min for each channel for each type of signal, in order to get the
%color limits of each channels

%type of signal A
color_signal_max_ch1 = 0; %pivot values, it is going to change
color_signal_min_ch1 = 1000; %pivot values, it is going to change
color_signal_max_ch2 = 0; 
color_signal_min_ch2 = 1000;
color_signal_max_ch3 = 0; 
color_signal_min_ch3 = 1000;

 
disp('Press Enter or Button click to display the next image:')
figure,
%Read train split images
for idx = 1:size(trainSet,2)
    
    %Just for type sign A
    %{
    filePath = strcat('..\train\gt\gt.' trainSet{idx} '.txt');
        [unused signs] = LoadAnnotations(filePath);
    im_test = imread(['..\train\' trainSet{idx} '.jpg']);
    im_mask = imread(['..\train\mask\mask.' trainSet{idx} '.png']);
    %}
    
    %Histogram Equalization
    r=im_test(:,:,1);
    g=im_test(:,:,2);
    b=im_test(:,:,3);
    r1 = histeq(r);
    g1 = histeq(g);
    b1 = histeq(b);
    im_test = cat(3,r1,g1,b1);
    %imshow(im_test_eq);
    
    %im_test = double(im_test)/255;        % Cast to double in the range [0,1]
    
    %Convert to another color space
    im_test = colorspace('HSV<-RGB',im_test);
    
    %compare if
    im_test_signal = bsxfun(@times, im_test, cast(im_mask,class(im_test)));
   
    
    
    
    ch1 = im_test_signal(:,:,1);
    current_max_ch1 = max(max(ch1(ch1~=0)));
    current_min_ch1 = min(min(ch1(ch1~=0)));
    if(color_signal_max_ch1<current_max_ch1)
        color_signal_max_ch1 = current_max_ch1;
    end
    
    if(color_signal_min_ch1<current_min_ch1)
        color_signal_min_ch1 = current_min_ch1;
    end
    
    ch2 = im_test_signal(:,:,2);
    current_max_ch2 = max(max(ch2(ch2~=0)));
    current_min_ch2 = min(min(ch2(ch2~=0)));
    if(color_signal_max_ch2<current_max_ch2)
        color_signal_max_ch2 = current_max_ch2;
    end
    
    if(color_signal_min_ch2<current_min_ch2)
        color_signal_min_ch2 = current_min_ch2;
    end
    
    ch3 = im_test_signal(:,:,3);
    current_max_ch3 = max(max(ch3(ch3~=0)));
    current_min_ch3 = min(min(ch3(ch3~=0)));
    if(color_signal_max_ch3<current_max_ch3)
        color_signal_max_ch3 = current_max_ch3;
    end
    
    if(color_signal_min_ch3<current_min_ch3)
        color_signal_min_ch3 = current_min_ch3;
    end
    
    
end
color_signal_max_ch1
color_signal_max_ch2
color_signal_max_ch3
color_signal_min_ch1
color_signal_min_ch2
color_signal_min_ch3

for idx = 1:size(trainSet,2)
    im_test = imread(['..\train\' trainSet{idx} '.jpg']);
    %Histogram Equalization
    r=im_test(:,:,1);
    g=im_test(:,:,2);
    b=im_test(:,:,3);
    r1 = histeq(r);
    g1 = histeq(g);
    b1 = histeq(b);
    im_test = cat(3,r1,g1,b1);
    
    % Change color space and plot it
   
    subplot(2,2,1);
    image(im_test);
    axis image
    %Change colorspace
    B = colorspace('HSV<-RGB',im_test); 
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
    
%channel 1    
C = C | (B(:,:,1) > color_signal_min_ch1 & B(:,:,1) < color_signal_max_ch1 & B(:,:,2) > color_signal_min_ch2 & B(:,:,2) < color_signal_max_ch1 & B(:,:,3) > color_signal_min_ch3 & B(:,:,3) < color_signal_max_ch1);
subplot(2,2,1), imshow(C)

w = waitforbuttonpress;
end

end