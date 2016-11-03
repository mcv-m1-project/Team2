function windowCandidates = slidingWindow_edges(image_edges, width0, height0, stepW0, stepH0, sizesrange, thresholdDT)

% Initializing structures:
windowCandidates = [];
windows = [];

% Loading model signals:
load('grayModels.mat')

% Size of image:
[N, M] = size(image_edges);

% Initialize cell array with the templates models. In this cell
% array, these models will be resized, so they will not be the same as the
% ones loaded previously.
templates = cell(4);

%calculate distance transform of edge's image
bwdist(image_edges);

% Apply Distance Transform to image:
image_dt = bwdist(image_edges);

% Loop over sizes:
for sizefactor = sizesrange
    
    sizefactor
    
    % Resizing width and height:
    height = max(round(height0 * sqrt(sizefactor)), 1);
    width = max(round(width0 * sqrt(sizefactor)), 1);
    % Resizing the steps:
    stepW = max(round(stepW0 * sizefactor), 1);
    stepH = max(round(stepH0 * sizefactor), 1);
    % Resizing threshold (to be consisten with the size of the window):
    thresholdDT_resized = thresholdDT * sizefactor^2;
    
    % Adjust size of models to fit the windows:
    templates{1} = imresize(circleTemp, [height, width]);
    templates{2} = imresize(squareTemp, [height, width]);
    templates{3} = imresize(upTriangleTemp, [height, width]);
    templates{4} = imresize(downTriangleTemp, [height, width]);
    
    % Compute edges from gray models:
    templates{1} = edge(templates{1}, 'canny');
    templates{2} = edge(templates{2}, 'canny');
    templates{3} = edge(templates{3}, 'canny');
    templates{4} = edge(templates{4}, 'canny');

    % Trying all windows over the image:
%     filas = length(1 : stepH : N-height+1)
%     columnas = length(1 : stepW : M-width+1)
%     scores = zeros(filas, columnas);
%     fila = 0;
    for n = 1 : stepH : N-height+1
%         fila = fila + 1;
%         colum = 0;
        for m = 1 : stepW : M-width+1
%             colum = colum + 1;
            % Content of the image in the window:
            subIm = image_dt(n : n+height-1, m : m+width-1);

            % We try with the four different signals shapes:
            % (circle, square, and up and down triangles)
            minWindowScore = height * width * sqrt(height * width); % Initialize with a very high value.
            for signal_shape = 1:4
                % Sum of product of the edge models and the Distance
                % Transform of the image:
                windowScore = sum(sum(templates{signal_shape} .* subIm));

                % Minimum score between the different shapes:
                minWindowScore = min(minWindowScore, windowScore);
            end
            
%             scores(fila, colum) = minWindowScore;

            % Deciding if the window is a candidate:
            if(minWindowScore < thresholdDT_resized)
                fprintf('%f     %f\n', minWindowScore, thresholdDT_resized)
                windows = [windows, struct('x', m, 'y', n, 'w', width, 'h', height)];
            end
        end
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

fprintf('Number of detected windows: %i\n', length(windows))

% Delete overlapped detections (union)
imPos = 1:M*N;
imPos = reshape(imPos,[N,M]);
if(0 == isempty(windows))
    % We directly add the first window:
    windowCandidates = windows(1);
    
    % Loop over the rest of the cadidate windows:
    for winPos = 2:length(windows)
        winPos
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



