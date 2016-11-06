function windowCandidates = slidingWindow_edges2(image_dt, widths, heights, thresholdDTs)

% Initializing structures:
windowCandidates = [];
windows = [];

% Loading model signals:
load('grayModels.mat')

% Size of image:
[N, M] = size(image_dt);

% Initialize cell array with the templates models. In this cell
% array, these models will be resized, so they will not be the same as the
% ones loaded previously.
templates = cell(4);


% Loop over sizes:
for i=1:length(thresholdDTs);
    %  for i=1:1;
    % Resizing width and height:
    height = heights(i);
    width = widths(i);
    % Resizing the steps:
    stepW = round(width * 0.2);
    stepH = round(height * 0.2);
    
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
            %             fprintf('scores: %f     ths: %f \n', minWindowScore, thresholdDTs(i))
            %
            if(minWindowScore < thresholdDTs(i)*0.4)
                windows = [windows, struct('x', m, 'y', n, 'w', width, 'h', height)];
            end
            
           end
    end
    
    %fprintf('Number of detected windows: %i\n', length(windows))
    
    windowCandidates = Clear_overlap(windows,image_dt);
end



