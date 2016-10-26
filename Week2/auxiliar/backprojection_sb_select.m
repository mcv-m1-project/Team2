function params = backprojection_sb_select(min_recall, filename)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab colorspace:

% Loading results:
load(filename);

max_precision = 0;
nbins_max = 0;
threshold_max = 0;
r_max = 0;
recall = 0;
for idx1 = 1:length(nbins_vec)
    for idx2 = 1:length(thresholds_vec)
        for idx3 = 1:length(r_vec)
            if(recall_array(idx1, idx2) >= min_recall)
                if(precision_array(idx1, idx2) >= max_precision)
                    nbins_max = nbins_vec(idx1);
                    threshold_max = thresholds_vec(idx2);
                    r_max = r_vec(idx3);
                    max_precision = precision_array(idx1, idx2, idx3);
                    recall = recall_array(idx1, idx2, idx3);
                end
            end
        end
    end
end
fprintf('\nMaximum precision found: %f\n', max_precision)
fprintf('Recall = %f\n', recall)
fprintf('Corresponds to the following parameters:\n')
fprintf('nbins = %i\n', nbins_max)
fprintf('threshold = %i\n', threshold_max)
fprintf('r = %i\n\n', r_max)

params.nbins = nbins_max;
params.threshold = threshold_max;
params.r = r_max;

return

end


