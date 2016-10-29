function nameslist = get_filenames(directory, type)

% Depending on the type of file we are looking for, we select a certain
% shape for its name:
if(strcmp(type, 'image'))
    patronini = '^.';
    patronfin = '\.jpg$';
elseif(strcmp(type, 'gt'))
    patronini = '^gt\.';
    patronfin = '\.txt$';
elseif(strcmp(type, 'mask'))
    patronini = '^mask\.';
    patronfin = '\.png$';
else
    error('File type not recognized')
end

% Get the names of the images:
if(exist(directory, 'dir') == 7)
    dirlist = dir(directory);
else
    error('Directory not found.')
end
nameslist = cell(0);
nfiles = 0;
for i = 1:length(dirlist)
    name = dirlist(i).name;
    % I check the name fits in the description:
    if(~isempty(regexp(name, [patronini, '.*', patronfin])))
        nfiles = nfiles + 1;
        % I get the name, taking out the beggining and the ending:
        nameslist{nfiles} = name(regexp(name, patronini) : (regexp(name, patronfin)-1));
    end
end

return

end