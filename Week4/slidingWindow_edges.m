function [mask, windowCandidates] = slidingWindow_edges(image_edges, width0, height0, stepW0, stepH0, sizesrange)

% Initializing structures:
windowCandidates = [];
windows = [];
candidates = [];
score = [];

% Loading Distance Transforms of model signals:
load('DTModels.mat')

% Size of image:
[N, M] = size(image_edges);

% Initialize cell array with the Distance Transform models. In this cell
% array, these models will be resized, so they will not be the same as the
% ones loaded previously.
DT = cell(4);

% Loop over sizes:
for sizefactor = sizesrange
    % Resizing width and height:
    height = round(height0 * sizefactor);
    width = round(width0 * sizefactor);
    % Resizing the steps:
    stepW = round(stepW0 * sizefactor);
    stepH = round(stepH0 * sizefactor);
    
    % Adjust size of DT to fit the windows:
    DT{1} = imresize(circleDT, [height, width]);
    DT{2} = imresize(squareDT, [height, width]);
    DT{3} = imresize(upTriangleDT, [height, width]);
    DT{4} = imresize(downTriangleDT, [height, width]);

    % Trying all windows over the image:
    for n = 1 : stepH : N-height+1
        for m = 1 : stepW : M-width+1
            % Content of the image in the window:
            subIm = image_edges(n : n+height-1, m : m+width-1);

            % We try with the four different signals shapes:
            % (circle, square, and up and down triangles)
            maxWindowScore = 0;
            for signal_shape = 1:4
                % Sum of product of the Distance Transform and the edges in 
                % the window:
                windowScore = sum(sum(DT{signal_shape} .* subIm));
                
                % Maxmum score between the different shapes:
                maxWindowScore = max(maxWindowScore, windowScore);
            end

            % Deciding if the window is a candidate:
            if(maxWindowScore > thresholdDT)
                windows = [windows, struct('x', m, 'y', n, 'w', width, 'h', height)];
                candidates = [candidates; m, n, width, height];
                score = [score; filling_ratio];
            end
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



