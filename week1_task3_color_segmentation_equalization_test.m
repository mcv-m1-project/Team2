function week1_task3_color_segmentation_equalization_test(dirTrainDataSet, trainSet)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset
%       'trainSet' - Array of images used for training

%create a max and a min for each channel for each type of signal, in order to get the
%color limits of each channels

%type of signal A

disp('Press Enter or Button click to display the next image:')
% figure,
%Read train split images
hist_a_acc=zeros(64,64);
hist_b_acc=zeros(64,64);
hist_c_acc=zeros(64,64);
hist_d_acc=zeros(64,64);
hist_e_acc=zeros(64,64);
hist_f_acc=zeros(64,64);

counter_type_a = 0;
for idx = 1:size(trainSet,2) 
    %Just for type sign A
    [~, signs_type] = LoadAnnotations([dirTrainDataSet '\gt\gt.' trainSet{idx} '.txt']);
    
        im_test = imread([dirTrainDataSet '\' trainSet{idx} '.jpg']);
        im_mask = imread([dirTrainDataSet '\mask\mask.' trainSet{idx} '.png']);
        
        im_test = double(im_test)/255;        % Cast to double in the range [0,1]
        %Convert to another color space
        im_test = colorspace('Lab<-RGB',im_test);
        %compare if
        im_test_signal = bsxfun(@times, im_test, cast(im_mask,class(im_test)));

        ch_a = im_test_signal(:,:,2);
        ch_b = im_test_signal(:,:,3);
           
        h = hist3(double([ch_a(:) ch_b(:)]), [64 64]);
        [m idx] = max(h(:));
        h(idx) = 0;
        switch signs_type{1}
            case 'A'
             hist_a_acc = hist_a_acc + h;
            case 'B'
             hist_b_acc = hist_b_acc + h;
            case 'C'
             hist_c_acc = hist_c_acc + h;
            case 'D'
             hist_d_acc = hist_d_acc + h;
            case 'E'
             hist_e_acc = hist_e_acc + h;
            case 'F'
             hist_f_acc = hist_f_acc + h;
        end
end
figure, bar3(hist_a_acc), title('A'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_b_acc), title('B'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_c_acc), title('C'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_d_acc), title('D'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_e_acc), title('E'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_f_acc), title('F'), xlabel('a component'), ylabel('b component')


for idx = 1:size(trainSet,2)
    im_test = imread(['..\train\' trainSet{idx} '.jpg']);
    %Histogram Equalization
%     r=im_test(:,:,1);
%     g=im_test(:,:,2);
%     b=im_test(:,:,3);
%     r1 = histeq(r);
%     g1 = histeq(g);
%     b1 = histeq(b);
%     im_test = cat(3,r1,g1,b1);
    im_test = double(im_test)/255;        % Cast to double in the range [0,1]
    % Change color space and plot it
   
    subplot(2,2,1);
    image(im_test);
    axis image
    title Mask
    %Change colorspace
    B = colorspace('Lab<-RGB',im_test); 
    %Plot every channel separately
    % View the individual channels
    subplot(2,2,2);
    imagesc(B(:,:,1));
    colormap(gray(256));
    axis image
    title H
    subplot(2,2,3);
    imagesc(B(:,:,2));
    colormap(gray(256));
    axis image
    title S
    subplot(2,2,4);
    imagesc(B(:,:,3));
    colormap(gray(256));
    axis image
    title V
    
    B(:,:,2) = histeq( B(:,:,2),256);
    B(:,:,3) = histeq( B(:,:,3),256);
%Signal type A   
C = (B(:,:,2) >= color_signal_min_ch1 & B(:,:,2) <= color_signal_max_ch1 & B(:,:,3) >= color_signal_min_ch2 & B(:,:,3) <= color_signal_max_ch2 );
subplot(2,2,1), imshow(C)

w = waitforbuttonpress;
end

end