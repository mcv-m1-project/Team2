function week1_task3_signal_types_1D_histograms(dirTrainDataSet, trainSet, signals)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset
%       'trainSet' - Array of images used for training
%       'signals' - Array of objects with all the information about each signal


bins = 256;
% Initialize histograms and counters:
hist_a_ch_a_acum=zeros(bins,1);
hist_a_ch_b_acum=zeros(bins,1);
hist_b_ch_a_acum=zeros(bins,1);
hist_b_ch_b_acum=zeros(bins,1);
hist_c_ch_a_acum=zeros(bins,1);
hist_c_ch_b_acum=zeros(bins,1);
hist_d_ch_a_acum=zeros(bins,1);
hist_d_ch_b_acum=zeros(bins,1);
hist_e_ch_a_acum=zeros(bins,1);
hist_e_ch_b_acum=zeros(bins,1);
hist_f_ch_a_acum=zeros(bins,1);
hist_f_ch_b_acum=zeros(bins,1);

counter_type_a = 0;
counter_type_b = 0;
counter_type_c = 0;
counter_type_d = 0;
counter_type_e = 0;
counter_type_f = 0;

for idx = 1:size(trainSet,2) 

%     [~, signs_type] = LoadAnnotations([dirTrainDataSet '\gt\gt.' trainSet{idx} '.txt']);
%     im_test = imread([dirTrainDataSet '\' trainSet{idx} '.jpg']);
%     im_mask = imread([dirTrainDataSet '\mask\mask.' trainSet{idx} '.png']);

    im_index = find( strcmp({signals(:).filename},trainSet{idx}));
    if (isempty(im_index) == 0)
        %Each image can contain more than one signal
        for jdx=1:size(im_index)
            im_test = signals(im_index(jdx)).image;
            im_mask = signals(im_index(jdx)).mask;
            
            % Cast to double in the range [0,1]
            im_test = double(im_test)/255;
            %Convert to another color space
            im_test = colorspace('Lab<-RGB',im_test);
            %compare if
            im_test_signal = bsxfun(@times, im_test, cast(im_mask,class(im_test)));
            
            %im_test_signal(find(~im_test_signal)) = NaN;
            
            ch_a = im_test_signal(:,:,2);
            ch_b = im_test_signal(:,:,3);
            
            
            h_ch_a = imhist(ch_a,bins);
            h_ch_b = imhist(ch_b,bins);
            
            switch signals(im_index(jdx)).type
                case 'A'
                    hist_a_ch_a_acum = hist_a_ch_a_acum + h_ch_a;
                    hist_a_ch_b_acum = hist_a_ch_b_acum + h_ch_b;
                    counter_type_a = counter_type_a + 1;
                case 'B'
                    hist_b_ch_a_acum = hist_b_ch_a_acum + h_ch_a;
                    hist_b_ch_b_acum = hist_b_ch_b_acum + h_ch_b;
                    counter_type_b = counter_type_b + 1;
                case 'C'
                    hist_c_ch_a_acum = hist_c_ch_a_acum + h_ch_a;
                    hist_c_ch_b_acum = hist_c_ch_b_acum + h_ch_b;
                    counter_type_c = counter_type_c + 1;
                case 'D'
                    hist_d_ch_a_acum = hist_d_ch_a_acum + h_ch_a;
                    hist_d_ch_b_acum = hist_d_ch_b_acum + h_ch_b;
                    counter_type_d = counter_type_d + 1;
                case 'E'
                    hist_e_ch_a_acum = hist_e_ch_a_acum + h_ch_a;
                    hist_e_ch_b_acum = hist_e_ch_b_acum + h_ch_b;
                    counter_type_e = counter_type_e + 1;
                case 'F'
                    hist_f_ch_a_acum = hist_f_ch_a_acum + h_ch_a;
                    hist_f_ch_b_acum = hist_f_ch_b_acum + h_ch_b;
                    counter_type_f = counter_type_f + 1;
            end
        end
    end
end

%Average each histogram

%for first channel
hist_a_ch_a_acum = hist_a_ch_a_acum./counter_type_a;
hist_b_ch_a_acum = hist_b_ch_a_acum./counter_type_b;
hist_c_ch_a_acum = hist_c_ch_a_acum./counter_type_c;
hist_d_ch_a_acum = hist_d_ch_a_acum./counter_type_d;
hist_e_ch_a_acum = hist_e_ch_a_acum./counter_type_e;
hist_f_ch_a_acum = hist_f_ch_a_acum./counter_type_f;

%for secdnd channel
hist_a_ch_b_acum = hist_a_ch_b_acum./counter_type_a;
hist_b_ch_b_acum = hist_b_ch_b_acum./counter_type_b;
hist_c_ch_b_acum = hist_c_ch_b_acum./counter_type_c;
hist_d_ch_b_acum = hist_d_ch_b_acum./counter_type_d;
hist_e_ch_b_acum = hist_e_ch_b_acum./counter_type_e;
hist_f_ch_b_acum = hist_f_ch_b_acum./counter_type_f;

%Normalize histograms
% hist_a_acc = hist_a_acc./max(max(hist_a_acc));
% hist_b_acc = hist_b_acc./max(max(hist_b_acc));
% hist_c_acc = hist_c_acc./max(max(hist_c_acc));
% hist_d_acc = hist_d_acc./max(max(hist_d_acc));
% hist_e_acc = hist_e_acc./max(max(hist_e_acc));
% hist_f_acc = hist_f_acc./max(max(hist_f_acc));

fprintf('Number of A type signals processed: %d\n', counter_type_a)
fprintf('Number of B type signals processed: %d\n', counter_type_b)
fprintf('Number of C type signals processed: %d\n', counter_type_c)
fprintf('Number of D type signals processed: %d\n', counter_type_d)
fprintf('Number of E type signals processed: %d\n', counter_type_e)
fprintf('Number of F type signals processed: %d\n', counter_type_f)

%erase zeros
hist_a_ch_a_acum(1)=0;
hist_b_ch_a_acum(1)=0;
hist_c_ch_a_acum(1)=0;
hist_d_ch_a_acum(1)=0;
hist_e_ch_a_acum(1)=0;
hist_f_ch_a_acum(1)=0;

hist_a_ch_b_acum(1)=0;
hist_b_ch_b_acum(1)=0;
hist_c_ch_b_acum(1)=0;
hist_d_ch_b_acum(1)=0;
hist_e_ch_b_acum(1)=0;
hist_f_ch_b_acum(1)=0;

%correct histogram
hist_a_ch_a_acum(end)=0;
hist_b_ch_a_acum(end)=0;
hist_c_ch_a_acum(end)=0;
hist_d_ch_a_acum(end)=0;
hist_e_ch_a_acum(end)=0;
hist_f_ch_a_acum(end)=0;

hist_a_ch_b_acum(end)=0;
hist_b_ch_b_acum(end)=0;
hist_c_ch_b_acum(end)=0;
hist_d_ch_b_acum(end)=0;
hist_e_ch_b_acum(end)=0;
hist_f_ch_b_acum(end)=0;


% %Histograms for the first channel
% figure, bar(hist_a_ch_a_acum), title('A_ch_a'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_b_ch_a_acum), title('B_ch_a'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_c_ch_a_acum), title('C_ch_a'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_d_ch_a_acum), title('D_ch_a'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_e_ch_a_acum), title('E_ch_a'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_f_ch_a_acum), title('F_ch_a'), xlabel('a component'), ylabel('b component')
% 
% % %Histograms for the second channel
% figure, bar(hist_a_ch_b_acum), title('A_ch_b'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_b_ch_b_acum), title('B_ch_b'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_c_ch_b_acum), title('C_ch_b'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_d_ch_b_acum), title('D_ch_b'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_e_ch_b_acum), title('E_ch_b'), xlabel('a component'), ylabel('b component')
% figure, bar(hist_f_ch_b_acum), title('F_ch_b'), xlabel('a component'), ylabel('b component')


hist_ch_a_acum = hist_a_ch_a_acum(1)+hist_b_ch_a_acum + hist_c_ch_a_acum + hist_d_ch_a_acum + hist_e_ch_a_acum + hist_f_ch_a_acum;
hist_ch_b_acum = hist_a_ch_b_acum(1)+hist_b_ch_b_acum + hist_c_ch_b_acum + hist_d_ch_b_acum + hist_e_ch_b_acum + hist_f_ch_b_acum;

% figure, bar(hist_ch_a_acum), title('hist ch_a acum'), xlabel('a component')
% figure, bar(hist_ch_b_acum), title('hist ch_b acum'), xlabel('b component')

%find thresholdss
t_ch_a=otsuthresh(hist_ch_a_acum)+0.25;
t_ch_b=otsuthresh(hist_ch_b_acum)-0.25;

t_ch_a
t_ch_b
save('1D_channel_a_threshold', 't_ch_a');
save('1D_channel_b_threshold', 't_ch_b');

[unused,trainSize] = size(trainSet);
for image = 1:trainSize 
   im_orig = imread([dirTrainDataSet '\' trainSet{image} '.jpg']);
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
   imwrite(mask,[dirTrainDataSet '\result_mask\1D_histogram\train\' trainSet{image} '.png']);
end

end