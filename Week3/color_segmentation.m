function [mask] = color_segmentation(im, th, bins, red_hist, blue_hist, rb_hist)

    im_h = im(:,:,1);
    im_s = im(:,:,2);
    
    pixels = [im_h(:) im_s(:)];
    pixels = ceil(pixels*bins); % from pixels to bins
    pixels(pixels==0) = 1;
    
    mask = zeros(size(im_h));
    mask = reshape(mask, [size(mask, 1)*size(mask, 2), 1]);
    
    for p=1:size(mask, 1)
        hist_i = pixels(p,1);
        hist_j = pixels(p,2);
        mask(p) = (red_hist(hist_i, hist_j) > th) | (blue_hist(hist_i, hist_j) > th) | (rb_hist(hist_i, hist_j) > th);
    end
    mask = reshape(mask, size(im_h));

end