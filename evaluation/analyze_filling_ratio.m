function filling_ratio = analyze_filling_ratio(dirgt, gt_list, dirmask, mask_list)
    % analyze_filling_ratio
    % Compute the filling ratio for each signal in the dataset.
    %
    %   filling_ratio = analyze_filling_ratio(dirgt, gt_list, dirmask, mask_list)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'dirgt'             Directory where to search for annotations files
    %    'gt_list'           Cell array with the names of the annotations files
    %    'dirmask'           Directory where to search for mask files
    %    'mask_list'         Cell array with the names of the mask files
    %
    % The function returns a vector with the filling ratio of each signal.
    % filling_ratio = mask_area / bbox_area.


    nfiles = length(gt_list); % Number of files with annotations.
    nsignals = 0; % Initialize total number of signals found.
    filling_ratio = []; % Initialize vector with form factor of each signal.

    % Loop over the files:
    for file = 1:nfiles
        % Annotations reading:
        gt_file = [dirgt, '\', gt_list{file}];
        [annotations, ~] = LoadAnnotations(gt_file);
        
        % Mask reading:
        mask_file = [dirmask, '\', mask_list{file}];
        mask = imread(mask_file);

        % Loop over the signals found in the file:
        for i = 1:length(annotations)
        
            % Rounding of coordinates to get integer numbers:
            % WHY ARE COORDINATES NOT INTEGER DIRECTLY ???????????
            xround = round(annotations(i).x);
            yround = round(annotations(i).y);
            hround = round(annotations(i).h);
            wround = round(annotations(i).w);
        
            nsignals = nsignals + 1;
            
            % Area of the box:
            bbox_area = hround * wround;
            
            % Area of the mask:
            rowrange = yround : (yround + hround - 1);
            colrange = xround : (xround + wround - 1);
            mask_area = 0;
            for row = rowrange
                for col = colrange
                    if(mask(row, col) > 0)
                        mask_area = mask_area + 1;
                    end
                end
            end
            
            if(mask_area > bbox_area)
                error('mask_area > bbox_area')
            end
            
            % Filling ratio:
            filling_ratio(nsignals) = mask_area / bbox_area;
        end
    end

    return
end







