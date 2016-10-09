function [gt_list, mask_list, images_list] = create_files_list(dirdataset)
    % create_files_list
    % Creates a list with the grount truth, mask and original image files
    % in the specified directory.
    %
    %   [gt_list, mask_list, images_list] = create_files_list(dirdataset)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'dirdataset'        Directory with orignal image files.
    %
    % We assume that maks files are in a subfolder called 'mask' adn ground
    % truth annotations in a subfolder called 'gt'.
    % All files starting with 'mask.' and ending with '.png' are considered
    % as masks, and those starting with 'gt.' and ending with '.txt' as
    % grount truth annotations. Original image files are supposed end with
    % '.jpg'.
    %
    % The function returns a cell array with the names of all grount truth
    % files (gt_list), a cell array with the names of all mask files
    % (mask_list), and a cell array with the names of all original image
    % files (imges_list).
    
    
    % Directories of grount truth annotations and masks:
    dirgt = [dirdataset, '\gt'];
    dirmask = [dirdataset, '\mask'];
    
    % We search in the annotations directory, and from it we extract the
    % images names. Then we use them to create the names of the files with
    % the masks and the original images:
    dirlist = dir(dirgt);
    nfiles = 0; % Initialize the number of files with ground truth annotations.
    gt_list = cell(0); % Initialize cell array with ground truth files names.
    mask_list = cell(0); % Initialize cell array with mask files names.
    images_list = cell(0); % Initialize cell array with image files names.
    % I go over dirlist, selecting those names which correspond to a ground
    % truth annotation:
    for i = 1:size(dirlist,1)
        name = dirlist(i).name;
        % I check the name ends with '.txt':
        if(~isempty(regexp(name, '^gt\..*\.txt$')))
            nfiles = nfiles + 1;
            % Name of the grount truth file:
            gt_list{nfiles} = name;
            % To get the name of the image, we substract the 'gt.' 
            % beggining, as well as the '.txt' ending, and then we add
            % '.jpg' at the end:
            simplename = name(4:(regexp(name, '\.txt$')-1));
            images_list{nfiles} = [simplename, '.jpg'];
            % Name of the mask file (we add 'mask.' at the beggining and
            % '.png' at the end):
            mask_list{nfiles} = ['mask.', simplename, '.png'];
        end
    end

    return
end







