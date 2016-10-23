function [mask] = maskCalculation(im_orig, hist_g1, hist_g2 ,hist_g3, th_g1, th_g2, th_g3)
%maskCalculation
%   Function that obtains the image corresponding mask depending on the
%   given thresholds
%
%   Parameters
%       'im_orig' - Path to the training dataset
%       'hist_g1' - Normalized histogram corresponding to G1 traffic signals
%       'hist_g2' - Normalized histogram corresponding to G2 traffic signals
%       'hist_g3' - Normalized histogram corresponding to G3 traffic signals
%       'th_g1' - Threshold to use on the 'hist_g1' to compute the mask
%       'th_g2' - Threshold to use on the 'hist_g2' to compute the mask
%       'th_g3' - Threshold to use on the 'hist_g3' to compute the mask
%   Returns
%       'mask' - Resulting mask after appling the histograms back-projection system

%Obtain the masks for each image on the training set
   numBins = length(hist_g1);
   im = double(im_orig)/255;
   im = colorspace('Lab<-RGB',im);
   [height,width,unused] = size(im);
   mask = zeros(height,width);
   for i = 1:height
       for j = 1:width
           %Find the histogram bin where the pixel color is represented
           a_component = ceil((im(i,j,2)+128)/(256/numBins)+1);
           b_component = ceil((im(i,j,3)+128)/(256/numBins)+1);
           %Decide if that pixel is part of a traffic signal or not
           if (hist_g1(a_component,b_component) >= th_g1 || hist_g2(a_component,b_component) >= th_g2 || hist_g3(a_component,b_component) >= th_g3)
               mask(i,j) = 1;
           end
       end
   end
end