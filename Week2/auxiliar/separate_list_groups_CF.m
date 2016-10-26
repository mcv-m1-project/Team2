function [listC, listF, listother] = separate_list_groups_CF(fileslist, signals)


lenlist = length(fileslist);
nsignals = length(signals);

listC = cell(0);
listF = cell(0);
listother = cell(0);

countC = 0;
countF = 0;
countother = 0;

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
            case 'C'
                countC = countC + 1;
                listC{countC} = signals(i).filename;

            case 'F'
                countF = countF + 1;
                listF{countF} = signals(i).filename;

            case {'A', 'B', 'D', 'E'}
                countother = countother + 1;
                listother{countother} = signals(i).filename;

            otherwise
                error('Signal type not recognized.')
        end
    end
end

return

end