function [listC, listDF, listE] = separate_list_groups_C(fileslist, signals)


lenlist = length(fileslist);
nsignals = length(signals);

listABC = cell(0);
listDF = cell(0);
listE = cell(0);

countABC = 0;
countDF = 0;
countE = 0;

for i = 1:nsignals
    % First we check if the file of signal(i) is in the list.
    flag = 0;
    for j = 1:lenlist
        if(strcmp(signals(i).filename, fileslist{j}))
            flag = 1;
            break
        end
    end
    
    if(flag)
        % Then we switch by the type of signal:
        switch signals(i).type
            case {'A', 'B', 'C'}
                countABC = countABC + 1;
                listABC{countABC} = signals(i).filename;

            case {'D', 'F'}
                countDF = countDF + 1;
                listDF{countDF} = signals(i).filename;

            case 'E'
                countE = countE + 1;
                listE{countE} = signals(i).filename;

            otherwise
                error('Signal type not recognized.')
        end
    end
end

return

end