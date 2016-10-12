function week1_task3_signal_types_2D_ab_histograms(dirTrainDataSet, trainSet, signals)
%week1_task3_color_segmentation_test
%   Use Lab color space to make the color mask.
%
%   Parameters
%       'dirTrainDataSet' - Path to the training dataset
%       'trainSet' - Array of images used for training
%       'signals' - Array of objects with all the information about each signal

% Initialize histograms and counters:
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
hist_a_acc = hist_a_acc./counter_type_a;
hist_b_acc = hist_b_acc./counter_type_b;
hist_c_acc = hist_c_acc./counter_type_c;
hist_d_acc = hist_d_acc./counter_type_d;
hist_e_acc = hist_e_acc./counter_type_e;
hist_f_acc = hist_f_acc./counter_type_f;

fprintf('Number of A type signals processed: %d\n', counter_type_a)
fprintf('Number of B type signals processed: %d\n', counter_type_b)
fprintf('Number of C type signals processed: %d\n', counter_type_c)
fprintf('Number of D type signals processed: %d\n', counter_type_d)
fprintf('Number of E type signals processed: %d\n', counter_type_e)
fprintf('Number of F type signals processed: %d\n', counter_type_f)

figure, bar3(hist_a_acc), title('A'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_b_acc), title('B'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_c_acc), title('C'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_d_acc), title('D'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_e_acc), title('E'), xlabel('a component'), ylabel('b component')
figure, bar3(hist_f_acc), title('F'), xlabel('a component'), ylabel('b component')

save('signal_types_ab_histograms', 'hist_a_acc', 'hist_b_acc', 'hist_c_acc', 'hist_d_acc', 'hist_e_acc', 'hist_f_acc');

end