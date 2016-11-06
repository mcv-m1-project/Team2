function windowCandidates = slidingWindow_edges_conv_square(image_edges, width0, height0, stepW0, stepH0, sizesrange, thresholdDT)

% Initializing structures:
windowCandidates = [];
windows = [];

% Loading model signals:
load('grayModels.mat')

% Size of image:
[N, M] = size(image_edges);

% Apply Distance Transform to image:
image_dt = double(bwdist(image_edges));

% Loop over sizes:
for sizefactor = sizesrange
    
    % Resizing width and height:
    height = max(round(height0 * sqrt(sizefactor)), 1);
    width = max(round(width0 * sqrt(sizefactor)), 1);
    % Resizing the steps:
    stepW = max(round(stepW0 * sizefactor), 1);
    stepH = max(round(stepH0 * sizefactor), 1);
    % Resizing threshold (to be consistent with the size of the window):
    threshold = thresholdDT * sizefactor^2;
    
    % Adjust size of models to fit the windows:
%     templates = imresize(circleTemp, [height, width]);
    templates = imresize(squareTemp, [height, width]);
%     templates = imresize(upTriangleTemp, [height, width]);
%     templates{4} = imresize(downTriangleTemp, [height, width]);
    
    % Compute edges from gray models:
    templates = double(edge(templates, 'canny'));
    
    % Center coordinates of the templates:
    rowcenter = floor((height + 1) / 2);
    colcenter = floor((width + 1) / 2);
    
    nrange = (1 : stepH : N-height+1) + rowcenter - 1;
    mrange = (1 : stepW : M-width+1) + colcenter - 1;
    
    % Compute the convolution with each model:
    kernel = templates(end:-1:1, end:-1:1);
    convimage = conv2(image_dt, kernel, 'same');
    scores = convimage(nrange, mrange);
    finalcandidates = scores < threshold;
    
    % Get non-zero elements of finalcandidates matrix:
    [icoord, jcoord, ~] = find(finalcandidates);
    
    for idx = 1:length(icoord)
        n = (icoord(idx) - 1) * stepH + 1;
        m = (jcoord(idx) - 1) * stepW + 1;
        windows = [windows, struct('x', m, 'y', n, 'w', width, 'h', height)];
    end
end

% %draw windows candidates
% figure()
% % img_candidates = image_edges;
% % imshow(img_candidates, [0 1])
% imshow(image_dt, [0 255])
% hold on
% for i=1:length(windows)
%     i
%     x = windows(i).x;
%     y = windows(i).y;
%     w = windows(i).w;
%     h = windows(i).h;
%     plot([x x], [y y+h], 'y')
%     plot([x+w x+w], [y y+h], 'y')
%     plot([x x+w], [y y], 'y')
%     plot([x x+w], [y+h y+h], 'y')
% end

% fprintf('Number of detected windows: %i\n', length(windows))

% Delete overlapped detections (union)
imPos = 1:M*N;
imPos = reshape(imPos,[N,M]);
if(0 == isempty(windows))
    % We directly add the first window:
    windowCandidates = windows(1);
    
    % Loop over the rest of the cadidate windows:
    for winPos = 2:length(windows)
        % Coordinates of current window:
        x_pos = windows(winPos).x;
        y_pos = windows(winPos).y;
        w_pos = windows(winPos).w;
        h_pos = windows(winPos).h;
        rectPos = imPos(y_pos : y_pos + h_pos - 1, x_pos : x_pos + w_pos - 1);
        
        % Flag to check if the window is new or if it is overlapped with
        % any other previously added:
        new = 1;
        
        % Loop over the previously selected windows:
        for winDef = 1:length(windowCandidates)
            % Coordinates of "Def" window:
            x_def = windows(winDef).x;
            y_def = windows(winDef).y;
            w_def = windows(winDef).w;
            h_def = windows(winDef).h;
            rectDef = imPos(y_def : y_def + h_def - 1, x_def : x_def + w_def - 1);
            
            % Intersection of both windows:
            int = intersect(rectPos, rectDef);
            if (0 == isempty(int)) %No empty means that both evaluated windows are overlapped
                new = 0;
                % Union of both windows:
                uni = union(rectPos, rectDef);
                [minY, minX] = find(imPos==min(uni));
                [maxY, maxX] = find(imPos==max(uni));
                winFin = struct('x', minX, 'y', minY, 'w', maxX-minX+1, 'h', maxY-minY+1);
                windowCandidates(winDef) = winFin;
                break;
            end
        end
        
        % If the window is not overlapped with any other, we consider it:
        if(new == 1)
            windowCandidates = [windowCandidates, windows(winPos)];
        end
    end
end

end



