function [mask, windowCandidates] = slidingWindowImage(im, width, height, stepW, stepH)

%set the values ot im to 0 and 1
im(im > 0) = 1;

windowCandidates = [];
%windows = [];
candidates = [];
score = [];

[N, M]=size(im);
for n=1:stepH:N-height
    for m=1:stepW:M-width
        subIm = im(n:min(N,n+height-1),m:min(M,m+width-1));
        filling_ratio = sum(sum(subIm))/(size(subIm,1)*size(subIm,2));
        %form_factor = width/height;
        if(filling_ratio > 0.5)
            %windows = [windows, struct('x',m,'y',n,'w',width,'h',height)];
            candidates = [candidates; m n width height];
            score = [score; filling_ratio];
        end
    end
end

%Delete overlapped detections (intersection)
% imPos = 1:M*N;
% imPos = reshape(imPos,[N,M]);
% windowCandidates = windows(1);
% for winPos=2:length(windows)
%     new = 1;
%     for winDef=1:length(windowCandidates)
%         rectPos = imPos(windows(winPos).y:windows(winPos).y+windows(winPos).h-1,windows(winPos).x:windows(winPos).x+windows(winPos).w-1);
%         rectDef = imPos(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1);
%         int = intersect(rectPos,rectDef);
%         if 0==isempty(int) %No empty means that both evaluated windows are overlapped
%             new = 0;
%             [minY,minX] = find(imPos==min(int));
%             [maxY,maxX] = find(imPos==max(int));
%             winFin = struct('x',minX,'y',minY,'w',maxX-minX+1,'h',maxY-minY+1);
%             windowCandidates(winDef)=winFin;
%             break;
%         end
%     end
%     if(new == 1)
%         windowCandidates = [windowCandidates windows(winPos)];
%     end
% end

%Delete overlapped detections (union)
% imPos = 1:M*N;
% imPos = reshape(imPos,[N,M]);
% windowCandidates = [];
% if(0==isempty(windows))
%     windowCandidates = windows(1);
%     for winPos=2:length(windows)
%         new = 1;
%         for winDef=1:length(windowCandidates)
%             rectPos = imPos(windows(winPos).y:windows(winPos).y+windows(winPos).h-1,windows(winPos).x:windows(winPos).x+windows(winPos).w-1);
%             rectDef = imPos(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1);
%             int = intersect(rectPos,rectDef);
%             if 0==isempty(int) %No empty means that both evaluated windows are overlapped
%                 new = 0;
%                 uni = union(rectPos,rectDef);
%                 [minY,minX] = find(imPos==min(uni));
%                 [maxY,maxX] = find(imPos==max(uni));
%                 winFin = struct('x',minX,'y',minY,'w',maxX-minX+1,'h',maxY-minY+1);
%                 windowCandidates(winDef)=winFin;
%                 break;
%             end
%         end
%         if(new == 1)
%             windowCandidates = [windowCandidates windows(winPos)];
%         end
%     end
% end

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