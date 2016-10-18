function [filling_ratio, form_factor] = get_fr_ff(signals)
    % get_fr_ff
    % Store the filling ratio and the form factor in two vectors, to
    % manipulate them more easily. In this process, we also detect missing
    % masks.
    %
    %   [filling_ratio, form_factor] = get_fr_ff(signals)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'signals'           Structure vector with all the signals.
    %
    % The function returns a two vectors, one with the filling ratio of
    % every signal, and another one with the form factor.
    
    filling_ratio = zeros(1,length(signals));
    form_factor = zeros(1,length(signals));
    for i = 1:length(signals)
        filling_ratio(i) = signals(i).filling_ratio;
        form_factor(i) = signals(i).form_factor;

        if(filling_ratio(i) == 0)
            fprintf('\nError found (filling_ratio = 0). Probably mask is missing.\n')
            fprintf('Name of file: %s.\n', signals(i).filename)
        end
    end
    
end







