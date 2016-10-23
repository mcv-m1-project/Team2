function [filling_ratio, form_factor, fr_means, ff_means] = ...
             get_fr_ff_bytypes(signals, signals_list, nrepetitions)
    % get_fr_ff_bytypes
    % Store the filling ratio and the form factor in two vectors, and
    % calculate their means within each signal type.
    %
    %   [filling_ratio, form_factor, fr_means, ff_means] = get_fr_ff_bytypes(signals, signals_list)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'signals'           Structure vector with all the signals.
    %    'signals_list'      Cell array with the names of the different
    %                        types of signals
    %    'nrepetitions'      Vector with the number of times each type of
    %                        signal appears.
    %
    % The function returns a two vectors, one with the filling ratio of
    % every signal, and another one with the form factor. It also returns
    % two vector, where each position corresond to a signal type, which
    % contain the filling ratio mean and the form factor mean.
    
    % Initializing vector with means of filling ratio and form factor:
    fr_means = zeros(1, length(signals_list));
    ff_means = zeros(1, length(signals_list));
    
    filling_ratio = zeros(1,length(signals));
    form_factor = zeros(1,length(signals));
    for i = 1:length(signals)
        filling_ratio(i) = signals(i).filling_ratio;
        form_factor(i) = signals(i).form_factor;

        for j = 1:length(signals_list)
            if(signals(i).type == signals_list{j})
                fr_means(j) = fr_means(j) + filling_ratio(i);
                ff_means(j) = ff_means(j) + form_factor(i);
                break
            end
        end
    end
    
    % We divide by the number of repetitions of each type of signal, to get
    % the mean:
    fr_means = fr_means ./ nrepetitions;
    ff_means = ff_means ./ nrepetitions;
end







