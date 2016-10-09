function form_factor = analyze_form_factor(dirgt, gt_list)
    % form_factor
    % Compute the form factor of each signal in the data set.
    %
    %   form_factor = analyze_form_factor(directory, filenames)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'dirgt'             Directory where to search for annotations files
    %    'gt_list'           Cell array with the names of the annotations files
    %
    % The function returns a vector with the form factor of each signal in
    % the dataset.
    % form factor = width / height.
    


    nfiles = length(gt_list); % Number of files with annotations.
    nsignals = 0; % Initialize total number of signals found.
    form_factor = []; % Initialize vector with form factor of each signal.

    % Loop over the files:
    for file = 1:nfiles
        % Annotations reading:
        filepath = [dirgt, '\', gt_list{file}];
        [annotations, ~] = LoadAnnotations(filepath);

        % Loop over the signals found in the file:
        for i = 1:length(annotations)
            nsignals = nsignals + 1;
            form_factor(nsignals) = annotations(i).w / annotations(i).h;
        end
    end

    return
end







