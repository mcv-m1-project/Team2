function [mask, window_candidates] = slidingWindow(im, width, height, stepW, stepH)

window_candidates = [];
mask = im*0;

[M, N]=size(im);
for m=1:stepW:M-width
    for n=1:stepH:N-height
        subIm = im(m:m+width,n:n+height);
        filling_ratio = sum(sum(subIm))/(width*height);
        form_factor = width/height; %¿Tiene sentido, depende de la ventana?
        if(filling_ratio > 0.5)
            window_candidates = [window_candidates, struct(m,n,width,height)];
            mask(m:m+width,n:n+height) = mask(m:m+width,n:n+height) + im(m:m+width,n:n+height);
        end
    end
end

%Delete overlapped detections


end