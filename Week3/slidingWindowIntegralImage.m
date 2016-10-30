function [mask, windowCandidates] = slidingWindowIntegralImage(im, width, height, stepW, stepH)

%set the values ot im to 0 and 1
im(im > 0) = 1;

windowCandidates = [];
windows = [];
candidates = [];
score = [];

[N, M]=size(im);
%Compute integral image:
ii = cumsum(cumsum(double(im)),2);
for n=1:stepH:N-height
    for m=1:stepW:M-width
%         sumII = ii(min(N,n+height-1),min(M,m+width-1)) - ii(n,min(M,m+width-1)) - ii(min(N,n+height-1),m) + ii(n,m);
        sumII = ii(min(N,n+height-1),min(M,m+width-1)) - ii(max(1,n-1),min(M,m+width-1)) - ii(min(N,n+height-1),max(1,m-1)) + ii(max(1,n-1),max(1,m-1));
        filling_ratio = sumII/(min(N-n+1, height)*min(M-m+1,width));
        if(filling_ratio > 0.5)
            windows = [windows, struct('x',m,'y',n,'w',width,'h',height)];
            candidates = [candidates; m n width height];
            score = [score; filling_ratio];
        end
    end
end

if(size(candidates,2)~=0)
    
    [selectedCandidates,selectedScore] = selectStrongestBbox(candidates,score);
    for winDef=1:size(selectedCandidates,1)
        windowCandidates = [windowCandidates, struct('x',int32(selectedCandidates(winDef,1)),'y',int32(selectedCandidates(winDef,2)),'w',int32(selectedCandidates(winDef,3)),'h',int32(selectedCandidates(winDef,4)))];
    end
    %Generate the final mask
     mask = im*0;
    for winDef=1:length(windowCandidates)
        mask(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1) = im(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1);
        %mask(windowCandidates(winDef,2):windowCandidates(winDef,2)+windowCandidates(winDef,4)-1,windowCandidates(winDef,1):windowCandidates(winDef,1)+windowCandidates(winDef,3)-1) = im(windowCandidates(winDef,2):windowCandidates(winDef,2)+windowCandidates(winDef,4)-1,windowCandidates(winDef,1):windowCandidates(winDef,1)+windowCandidates(winDef,3)-1);
    end
else
     mask = im;
end

end