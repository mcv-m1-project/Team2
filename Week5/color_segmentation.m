function [mask] = color_segmentation(labels,centers)

    bins = 32;
    sat_radiuses = 0.5;
    th = 0.004;
    
    hists = load('hists.mat');
    red_hist = hists.red_hist;
    blue_hist = hists.blue_hist;
    rb_hist = hists.rb_hist;
    
    red_hist(:,1:round(bins * sat_radiuses)) = 0;
    blue_hist(:,1:round(bins * sat_radiuses)) = 0;
    rb_hist(:,1:round(bins * sat_radiuses)) = 0;
    
    if size(centers,2) ~= 3
        centers = centers.';
    end
    
    colorCenters = centers(:,1);
    colorCenters(:,:,2) = centers(:,2);
    colorCenters(:,:,3) = centers(:,3);
    colorCenters = rgb2hsv(colorCenters);
    
    mask = labels*0;
    for i=1:size(colorCenters,1)
        bins = ceil([colorCenters(i,1,1)*bins,colorCenters(i,1,2)*32]); % from pixels to bins
        bins(bins==0) = 1;
        if (red_hist(bins(1), bins(2)) > th) || (blue_hist(bins(1), bins(2)) > th) || (rb_hist(bins(1), bins(2)) > th)
            mask(labels == i) = 1;
        else
            mask(labels == i) = 0;
        end
    end

end