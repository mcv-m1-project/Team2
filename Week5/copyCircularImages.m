function copyCircularImages(dirin, dirout)
% Copy all the images, gt, masks and CC masks that have circular signals,
% and paste them in the specified folder.

% Check for the existence of the output directory:
if(7 ~= exist(dirout, 'dir'))
    mkdir(dirout)
end
% The same for the subfolders:
if(7 ~= exist([dirout, '\gt'], 'dir'))
    mkdir([dirout, '\gt'])
end
if(7 ~= exist([dirout, '\mask'], 'dir'))
    mkdir([dirout, '\mask'])
end
if(7 ~= exist([dirout, '\result_masks\CC'], 'dir'))
    mkdir([dirout, '\result_masks\CC'])
end

fileslist = listFiles(dirin);
lenlist = length(fileslist);

load('signals_main_parameters.mat')
nsignals = length(signals);

% Loop over files:
for i = 1:lenlist
    filename = fileslist(i).name(1:end-4);
    
    % Flag to know if the file is in any signal.
    found = 0;
    
    % Flag to know if a file has any circular signal:
    hascircular = 0;
    
    % Loop over signals looking for the name of the signal:
    for j = 1:nsignals
        if(strcmp(signals(j).filename, filename))
            % Signal j belongs to file i.
            found = 1;
            
            % We check if the signal is of types C, D or E:
            if(signals(j).type == 'C' || signals(j).type == 'D' || signals(j).type == 'E')
                hascircular = 1;
                break
            end
            % If the signal is not circular, we continue the loop; in the
            % image there might be more than one signal.
        end
    end
    
    % If the image has a circular image, copy it (and its associated files)
    % to the output directories:
    if(hascircular)
        % Copy the image file:
        src = [dirin, '\', filename, '.jpg'];
        dst = [dirout, '\', filename, '.jpg'];
        copyfile(src, dst);
        
        % Copy the gt file:
        src = [dirin, '\gt\gt.', filename, '.txt'];
        dst = [dirout, '\gt\gt.', filename, '.txt'];
        copyfile(src, dst);
        
        % Copy the mask file:
        src = [dirin, '\mask\mask.', filename, '.png'];
        dst = [dirout, '\mask\mask.', filename, '.png'];
        copyfile(src, dst);
        
        % Copy the CC mask file:
        src = [dirin, '\result_masks\CC\', filename, '.png'];
        dst = [dirout, '\result_masks\CC\', filename, '.png'];
        copyfile(src, dst);
        
        % Copy the CC windows file:
        src = [dirin, '\result_masks\CC\', filename, '.mat'];
        dst = [dirout, '\result_masks\CC\', filename, '.mat'];
        copyfile(src, dst);
    end
    
    if(~found)
        warning('File %i does not appear in any signal.', i)
    end
    
end

return

end