function params = backprojection_kde_select(min_recall)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab colorspace:

% Loading results:
load('bp_kde_tuning_lab.mat');

max_precision_lab = 0;
h_lab_max = 0;
prctile_ths_lab_max = 0;
recall_lab = 0;
for idx1 = 1:length(h_vec)
    for idx2 = 1:length(prctile_ths_vec)
        if(recall_array(idx1, idx2) >= min_recall)
            if(precision_array(idx1, idx2) >= max_precision_lab)
                h_lab_max = h_vec(idx1);
                prctile_ths_lab_max = prctile_ths_vec(idx2);
                max_precision_lab = precision_array(idx1, idx2);
                recall_lab = recall_array(idx1, idx2);
            end
        end
    end
end
fprintf('\nMaximum precision found with lab: %f\n', max_precision_lab)
fprintf('Recall = %f\n', recall_lab)
fprintf('Corresponds to the following parameters:\n')
fprintf('h = %i\n', h_lab_max)
fprintf('prctile_ths = %i\n\n', prctile_ths_lab_max)


%%%%%%%%%%%%%%%%%%%%%%%%%
% hsv colorspace:

% Loading results:
load('bp_kde_tuning_hsv.mat');

max_precision_hsv = 0;
h_hsv_max = 0;
prctile_ths_hsv_max = 0;
recall_hsv = 0;
for idx1 = 1:length(h_vec)
    for idx2 = 1:length(prctile_ths_vec)
        if(recall_array(idx1, idx2) >= min_recall)
            if(precision_array(idx1, idx2) >= max_precision_hsv)
                h_hsv_max = h_vec(idx1);
                prctile_ths_hsv_max = prctile_ths_vec(idx2);
                max_precision_hsv = precision_array(idx1, idx2);
                recall_hsv = recall_array(idx1, idx2);
            end
        end
    end
end
fprintf('Maximum precision found with hsv: %f\n', max_precision_hsv)
fprintf('Recall = %f\n', recall_hsv)
fprintf('Corresponds to the following parameters:\n')
fprintf('h = %i\n', h_hsv_max)
fprintf('prctile_ths = %i\n\n', prctile_ths_hsv_max)


%%%%%%%%%%%%%%%%%%%%%%%%%
% Selecting colorspace for maximum:
if(max_precision_lab > max_precision_hsv) % Lab wins
    params.colorspace = 'lab';
    params.h = h_lab_max;
    params.prctile_ths = prctile_ths_lab_max;
    
else % hsv wins
    params.colorspace = 'hsv';
    params.h = h_hsv_max;
    params.prctile_ths = prctile_ths_hsv_max;
end

% Write results:
save('bp_kde_select.mat', 'params')

return

end


