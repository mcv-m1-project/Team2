function [hist_g1,hist_g2,hist_g3] = jointHistogramsByGroup(trainSet, signals, numBins)
%jointHistogramsByGroup
%   Function that computes the traffic signal 2D histograms in Lab color
%   space deviding them in three groups depending on its colors
%
%   Parameters
%       'trainSet' - Array of images used for training
%       'signals' - Array of objects with all the information about each signal
%       'numBins' - Number of bins that must be used to compute the histograms
%   Returns
%       'hist_g1' - Obtained 2D histogram for the traffic signs on Group 1
%       'hist_g2' - Obtained 2D histogram for the traffic signs on Group 2
%       'hist_g3' - Obtained 2D histogram for the traffic signs on Group 3

% Initialize histograms and counters:
hist_g1=zeros(numBins,numBins);
hist_g2=zeros(numBins,numBins);
hist_g3=zeros(numBins,numBins);

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
                      
            h = hist3(double([ch_a(:) ch_b(:)]), [numBins numBins]);
            % [m idx] = max(h(:));
            % h(idx) = 0;
            switch signals(im_index(jdx)).type
                case {'A','B','C'}
                    hist_g1 = hist_g1 + h;
                case {'D','F'}
                    hist_g2 = hist_g2 + h;
                case 'E'
                    hist_g3 = hist_g3 + h;
            end
        end
    end
end
%normalize the joint histograms
hist_g1 = hist_g1./sum(sum(hist_g1));
hist_g2 = hist_g2./sum(sum(hist_g2));
hist_g3 = hist_g3./sum(sum(hist_g3));


% figure, bar3(hist_g1), title('G1: A, B, C'), xlabel('a component'), ylabel('b component')
% figure, bar3(hist_g2), title('G2: D, F'), xlabel('a component'), ylabel('b component')
% figure, bar3(hist_g3), title('G3, E'), xlabel('a component'), ylabel('b component')

end