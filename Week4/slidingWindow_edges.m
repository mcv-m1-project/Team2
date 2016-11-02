function [mask, windowCandidates] = slidingWindow_edges(image_edges, width, height, stepW, stepH, sizes)

% Initializing structures:
windowCandidates = [];
windows = [];
candidates = [];
score = [];

% Loading Distance Transforms of model signals:
load('distanceTransformsModels.mat')

% Size of image:
[N, M]=size(image_edges);

%%%%%%%%%%%%  ADD SIZES  !!!!!!!!

% Trying all windows over the image:
for n = 1 : stepH : N-height+1
    for m = 1 : stepW : M-width+1
        % Content of the image in the window:
        subIm = image_edges(n : n+height-1, m : m+width-1);
        
        % Distance measure..........
        
        % We try with the four different signals shapes:
        % (circle, square, and up and down triangles)
        for signal_shape = 1:4
            
            %%%% CHOOSE DT !!!!
            %%%% ADJUST SIZE OF DT !!!!
            
            % Sum of product of the Distance Transform and the edges in 
            % the window:
            sumProdDT = sum(sum(DT .* subIm));
            
            if(sumProdDT > thresholdDT)
                
            end
            
        end
        
        % Condition about distance meausre.......
        if()
            windows = [windows, struct('x', m, 'y', n, 'w', width, 'h', height)];
            candidates = [candidates; m, n, width, height];
            score = [score; filling_ratio];
        end
    end
end


% Delete overlapped detections (union)
imPos = 1:M*N;
imPos = reshape(imPos,[N,M]);
windowCandidates = [];
if(0==isempty(windows))
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
end

% if(size(candidates,2)~=0)
    
%     [selectedCandidates,selectedScore] = selectStrongestBbox(candidates,score);
%     for winDef=1:size(selectedCandidates,1)
%         windowCandidates = [windowCandidates, struct('x',int32(selectedCandidates(winDef,1)),'y',int32(selectedCandidates(winDef,2)),'w',int32(selectedCandidates(winDef,3)),'h',int32(selectedCandidates(winDef,4)))];
%     end
    %Generate the final mask
     mask = image_edges*0;
    for winDef=1:length(windowCandidates)
        mask(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1) = image_edges(windowCandidates(winDef).y:windowCandidates(winDef).y+windowCandidates(winDef).h-1,windowCandidates(winDef).x:windowCandidates(winDef).x+windowCandidates(winDef).w-1);
        %mask(windowCandidates(winDef,2):windowCandidates(winDef,2)+windowCandidates(winDef,4)-1,windowCandidates(winDef,1):windowCandidates(winDef,1)+windowCandidates(winDef,3)-1) = im(windowCandidates(winDef,2):windowCandidates(winDef,2)+windowCandidates(winDef,4)-1,windowCandidates(winDef,1):windowCandidates(winDef,1)+windowCandidates(winDef,3)-1);
    end

end



