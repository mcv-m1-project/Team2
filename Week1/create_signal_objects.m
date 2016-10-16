function signals = create_signal_objects(dirgt, gt_list, dirmask, mask_list, dirimage, image_list)
    % create_signal_objects
    % Read all the information in the dataset, and store it in a vector of
    % objects.
    %
    %   signals = create_signal_objects(dirgt, gt_list, dirmask, mask_list, dirimage, image_list)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'dirgt'             Directory where to search for annotations files
    %    'gt_list'           Cell array with the names of the annotations files
    %    'dirmask'           Directory where to search for mask files
    %    'mask_list'         Cell array with the names of the mask files
    %    'dirimage'          Directory where to search for image files
    %    'image_list'        Cell array with the names of the image files
    %
    % The function returns a vector of objects, each representing one
    % signal. These objects are structures, with the following attributes:
    %     - image: subset of the original image contained in the window.
    %     - mask: subset of the mask contained in the window.
    %     - coordinates: coordinates of the window (x, y, w, h).
    %     - type: the part of the original image contained in the window.
    %     - filling_ratio.
    %     - form_factor.
    %     - filename: Name of the file where it appear (no endings nor
    %                 begginings).
    %     - nos_infile: Number of signal in the file. In some images there
    %                   are several signals. This number is the order in 
    %                   which appears in the gt file.

    % Initialize the signal object:
    signals(1) = struct('image', [], 'mask', [], 'coordinates', [], 'type', [], ...
                       'filling_ratio', [], 'form_factor', [], ...
                       'filename', [], 'nos_infile',[]);
    
    nfiles = length(gt_list); % Number of files with annotations.
    nsignals = 0; % Number of signals.

    % Loop over the files:
    for file = 1:nfiles
        % Annotations reading:
        filepath = [dirgt, '\', gt_list{file}];
        [coordinates, sign_types] = LoadAnnotations(filepath);
        
        % Mask reading:
        mask_file = [dirmask, '\', mask_list{file}];
        mask = imread(mask_file);
        
        % Image reading:
        image_file = [dirimage, '\', image_list{file}];
        image = imread(image_file);

        % Loop over the signals found in the file:
        for i = 1:length(sign_types)
            nsignals = nsignals + 1; % Add one signal to the count.
            
            % Get the coordinates of the window and round them:
            xround = round(coordinates(i).x);
            yround = round(coordinates(i).y);
            hround = round(coordinates(i).h);
            wround = round(coordinates(i).w);
            % Also, get the range of rows and columns of the window:
            rowrange = yround : (yround + hround - 1);
            colrange = xround : (xround + wround - 1);
            
            % Compute the area of the window:
            bbox_area = hround * wround;
            % Compute the area of the mask:
            mask_area = 0;
            for row = rowrange
                for col = colrange
                    if(mask(row, col) > 0)
                        mask_area = mask_area + 1;
                    end
                end
            end
            
            % Name of the file (without begginings nor terminations):
            filegt = gt_list{file};
            filename = filegt(4:(regexp(filegt, '\.txt$')-1));
            
            % Set the values of the signal object:
            signals(nsignals).coordinates = coordinates(i);
            signals(nsignals).type = sign_types{i};
            signals(nsignals).mask = mask(rowrange, colrange);
            signals(nsignals).image = image(rowrange, colrange, :);
            signals(nsignals).filling_ratio = mask_area / bbox_area;
            signals(nsignals).form_factor = coordinates(i).w / coordinates(i).h;
            signals(nsignals).filename = filename;
            signals(nsignals).nos_infile = i;
        end
    end

    return
end







