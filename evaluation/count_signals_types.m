function [signals_list, nrepetitions] = count_signals_types(signals)
    % count_signals_types
    % Get the different types of signals that appear in the annotations
    % at the given directory, and count how many times the appear.
    %
    %   [signals_list, nrepetitions] = count_signals_types(signals)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'signals'           Structure vector with all the signals.
    %
    % The function returns a cell array with the names of the different
    % signals found (signals_list) and a vector with the number of times
    % each signal appears. Both arrays are alphabetically ordered.


    nsignals = length(signals); % Number of signals
    signals_list = cell(0); % Initialize cell array with the names of the different types of signals.
    ntypes = 0; % Number of different signal types.
    nrepetitions = []; % Vector with the number of repetitions of each signal type.

    % Loop over the signals:
    for i = 1:nsignals
        % If the signal type has not been found yet, I add it to types_vec:
        flag = 1; % This will be 1, until a match is found between the current signal type and the vector with all signal types.
        for j = 1:length(signals_list)
            if(strcmp(signals(i).type, signals_list{j}))
                flag = 0;
                % A match was found, so we add one to the number of repetitions
                % of such signal type:
                nrepetitions(j) = nrepetitions(j) + 1;
                break;
            end
        end
        if(flag == 1)
            % No match found: we add the new signal type:
            ntypes = ntypes + 1;
            signals_list{ntypes} = signals(i).type;
            nrepetitions(ntypes) = 1;
        end
    end
    
    % Alphabetically sorting:
    [signals_list, ix] = sort(signals_list);
    nrepetitions = nrepetitions(ix);

    return
end







