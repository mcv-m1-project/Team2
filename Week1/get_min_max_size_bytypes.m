function [min_size, max_size] = get_min_max_size_bytypes(signals, signals_list, nrepetitions)
    % get_min_max_size_bytypes
    % Compute the minimum and maximum size of the signals of each type.
    %
    %   [min_size, max_size] = get_min_max_size_bytypes(signals, signals_list, nrepetitions)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'signals'           Structure vector with all the signals.
    %    'signals_list'      Cell array with the names of the different
    %                        types of signals
    %    'nrepetitions'      Vector with the number of times each type of
    %                        signal appears.
    %
    % The function returns a two vectors, one with the minimum size and
    % another one with the maximum size of the signals of each type. Size
    % is computed as width times height of the window.
    
    % Initializing vectors with minimum and maximum size for each type of
    % signal:
    min_size = zeros(1, length(signals_list));
    max_size = zeros(1, length(signals_list));
    
    % Vector to check if it is the first time we are finding one type of
    % singal. Depending on this, we will do one thing or another inside the
    % loop:
    initialized = zeros(1, length(signals_list));
    
    for i = 1:length(signals)
        for j = 1:length(signals_list) % We make a loop over all signal types
            if(signals(i).type == signals_list{j})
                size = signals(i).coordinates.h * signals(i).coordinates.w;
                if(initialized(j) == 0) %First time with this type of signal.
                    min_size(j) = size;
                    max_size(j) = size;
                    initialized(j) = 1;
                else % We have already found before this type of signal.
                    min_size(j) = min(min_size(j), size);
                    max_size(j) = max(max_size(j), size);
                end
                break
            end
        end
    end
end







