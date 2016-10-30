function [mask, windowCandidates] = slidingWindowConvolution(im, width, height, stepW, stepH)

%set the values ot im to 0 and 1
im(im > 0) = 1;

windowCandidates = [];
windows = [];
candidates = [];
score = [];

[N, M]=size(im);

% Kernel for the convolution:
kernel = double(ones(height, width));
% Central pixel of the kernel:
rowcenter = ceil((height - 1) / 2);
colcenter = ceil((width - 1) / 2);
%Compute the convolution:
convimage = conv2(double(im), kernel, 'same');



for n=1:stepH:N-height
    for m=1:stepW:M-width
        % Sum of active pixels inside the window:
        row = min(n + colcenter - 1, N);
        col = min(m + rowcenter - 1, M);
        sumwindow = convimage(row, col);
        
        % Filling ratio:
        filling_ratio = sumwindow / (min(N-n+1, height)*min(M-m+1,width));
        
        % Checking if we accept the window as a possible signal:
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
     mask = im*0;
end

end