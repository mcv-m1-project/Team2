function [mask, windowCandidates] = slidingWindowImage(im, width, height, stepW, stepH)

%set the values ot im to 0 and 1
im(im > 0) = 1;

windowCandidates = [];
mask = im*0;

[N, M]=size(im);
for n=1:stepH:N-height
    for m=1:stepW:M-width
        subIm = im(n:min(N,n+height),m:min(M,m+width));
        filling_ratio = sum(sum(subIm))/(width*height);
        form_factor = width/height; %¿Tiene sentido, depende de la ventana?
        if(filling_ratio > 0.5)
            windowCandidates = [windowCandidates, struct('m','n','width','height')];
            mask(n:min(N,n+height),m:min(M,m+width)) = mask(n:min(N,n+height),m:min(M,m+width)) + im(n:min(N,n+height),m:min(M,m+width));
        end
    end
end

%Delete overlapped detections
mask(mask > 0) = 1;

end