function [mask, windowCandidates] = slidingWindowImage(im, width, height, stepW, stepH)

%set the values ot im to 0 and 1
im(im > 0) = 1;

windows = [];

[N, M]=size(im);
for n=1:stepH:N-height
    for m=1:stepW:M-width
        subIm = im(n:min(N,n+height),m:min(M,m+width));
        filling_ratio = sum(sum(subIm))/(width*height);
        form_factor = width/height; %¿Tiene sentido, depende de la ventana?
        if(filling_ratio > 0.5)
            windows = [windows, struct('x',m,'y',n,'w',width,'h',height)];
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
imPos = 1:M*N;
imPos = reshape(imPos,[N,M]);
windowCandidates = windows(1);
for winPos=2:length(windows)
    new = 1;
    for winDef=1:length(windowCandidates)
        rectPos = imPos(windows(winPos).y:windows(winPos).y+windows(winPos).h-1,windows(winPos).x:windows(winPos).x+windows(winPos).w-1);
        rectDef = imPos(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1);
        int = intersect(rectPos,rectDef);
        if 0==isempty(int) %No empty means that both evaluated windows are overlapped
            new = 0;
            uni = union(rectPos,rectDef);
            [minY,minX] = find(imPos==min(uni));
            [maxY,maxX] = find(imPos==max(uni));
            winFin = struct('x',minX,'y',minY,'w',maxX-minX+1,'h',maxY-minY+1);
            windowCandidates(winDef)=winFin;
            break;
        end
    end
    if(new == 1)
        windowCandidates = [windowCandidates windows(winPos)];
    end
end  

%Generate the final mask
mask = im*0;
for winDef=1:length(windowCandidates)
    mask(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1) = im(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1);
end

mask2 = im*0;
for winDef=1:length(windows)
    mask2(windows(winDef).y:windows(winDef).y+windows(winDef).h-1,windows(winDef).x:windows(winDef).x+windows(winDef).w-1) = im(windows(winDef).y:windows(winDef).y+windows(winDef).h-1,windows(winDef).x:windows(winDef).x+windows(winDef).w-1);
end

end