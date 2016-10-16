function week1_task3_signal_types_2D_ab_histograms(dirTrainDataSet, trainSet, signals)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset
%       'trainSet' - Array of images used for training
%       'signals' - Array of objects with all the information about each signal

% Initialize histograms and counters:
tic
hist_a_acc=zeros(64,64);
hist_b_acc=zeros(64,64);
hist_c_acc=zeros(64,64);
hist_d_acc=zeros(64,64);
hist_e_acc=zeros(64,64);
hist_f_acc=zeros(64,64);

counter_type_a = 0;
counter_type_b = 0;
counter_type_c = 0;
counter_type_d = 0;
counter_type_e = 0;
counter_type_f = 0;

for idx = 1:size(trainSet,2) 
    
    %Compute the joint histograms for each signal type
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
            
            im_test_signal(find(~im_test_signal)) = NaN;
            
            ch_a = im_test_signal(:,:,2);
            ch_b = im_test_signal(:,:,3);
                      
            h = hist3(double([ch_a(:) ch_b(:)]), [64 64]);
            % [m idx] = max(h(:));
            % h(idx) = 0;
            switch signals(im_index(jdx)).type
                case 'A'
                    hist_a_acc = hist_a_acc + h;
                    counter_type_a = counter_type_a + 1;
                case 'B'
                    hist_b_acc = hist_b_acc + h;
                    counter_type_b = counter_type_b + 1;
                case 'C'
                    hist_c_acc = hist_c_acc + h;
                    counter_type_c = counter_type_c + 1;
                case 'D'
                    hist_d_acc = hist_d_acc + h;
                    counter_type_d = counter_type_d + 1;
                case 'E'
                    hist_e_acc = hist_e_acc + h;
                    counter_type_e = counter_type_e + 1;
                case 'F'
                    hist_f_acc = hist_f_acc + h;
                    counter_type_f = counter_type_f + 1;
            end
        end
    end
end
%normalize the joint histograms
hist_a_acc = hist_a_acc./counter_type_a;
hist_b_acc = hist_b_acc./counter_type_b;
hist_c_acc = hist_c_acc./counter_type_c;
hist_d_acc = hist_d_acc./counter_type_d;
hist_e_acc = hist_e_acc./counter_type_e;
hist_f_acc = hist_f_acc./counter_type_f;

% fprintf('Number of A type signals processed: %d\n', counter_type_a)
% fprintf('Number of B type signals processed: %d\n', counter_type_b)
% fprintf('Number of C type signals processed: %d\n', counter_type_c)
% fprintf('Number of D type signals processed: %d\n', counter_type_d)
% fprintf('Number of E type signals processed: %d\n', counter_type_e)
% fprintf('Number of F type signals processed: %d\n', counter_type_f)
% 
% figure, bar3(hist_a_acc), title('A'), xlabel('a component'), ylabel('b component')
% figure, bar3(hist_b_acc), title('B'), xlabel('a component'), ylabel('b component')
% figure, bar3(hist_c_acc), title('C'), xlabel('a component'), ylabel('b component')
% figure, bar3(hist_d_acc), title('D'), xlabel('a component'), ylabel('b component')
% figure, bar3(hist_e_acc), title('E'), xlabel('a component'), ylabel('b component')
% figure, bar3(hist_f_acc), title('F'), xlabel('a component'), ylabel('b component')
% 
% figure, subplot(2,3,1), imagesc(hist_a_acc), title('A'), xlabel('a component'), ylabel('b component')
% subplot(2,3,2), imagesc(hist_b_acc), title('B'), xlabel('a component'), ylabel('b component')
% subplot(2,3,3), imagesc(hist_c_acc), title('C'), xlabel('a component'), ylabel('b component')
% subplot(2,3,4), imagesc(hist_d_acc), title('D'), xlabel('a component'), ylabel('b component')
% subplot(2,3,5), imagesc(hist_e_acc), title('E'), xlabel('a component'), ylabel('b component')
% subplot(2,3,6), imagesc(hist_f_acc), title('F'), xlabel('a component'), ylabel('b component')

%Obtain the global join histogram
hist_acc = hist_a_acc + hist_b_acc + hist_c_acc + hist_d_acc + hist_e_acc + hist_f_acc;
% figure, bar3(hist_acc), title('global'), xlabel('a component'), ylabel('b component')

%Find the two most representitive colors (red and blue)
first_max = max(max(hist_acc));
[first_max_i,first_max_j] = find (hist_acc==first_max);
second_max = max(max(hist_acc(hist_acc < first_max)));
[second_max_i,second_max_j] = find (hist_acc==second_max);

%Compute the filter that is going to be used
hist_filter = zeros(64,64);
rad_blue = 13;
for i = max(first_max_i-rad_blue,1):min(first_max_i+rad_blue,64)
    for j = max(first_max_j-rad_blue,1):min(first_max_j+rad_blue,64)
        hist_filter(i,j) = 1;
    end
end
rad_red = 15;
for i = max(second_max_i-rad_red,1):min(second_max_i+rad_red,64)
    for j = max(second_max_j-rad_red,1):min(second_max_j+rad_red,64)
        hist_filter(i,j) = 1;
    end
end

hist_acc_filtered = hist_acc.*hist_filter;
% figure, bar3(hist_acc_filtered), title('filtered'), xlabel('a component'), ylabel('b component')
save('2d_ab_histograms_filter', 'hist_acc_filtered');

toc

%Obtain the masks for each image on the training set
[unused,trainSize] = size(trainSet);
for image = 1:trainSize
   im_orig = imread([dirTrainDataSet '\' trainSet{image} '.jpg']);
   %Change to Lab colorspace
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
   imwrite(mask,[dirTrainDataSet '\result_mask\2d_hist\train\' trainSet{image} '.png']);
end


end