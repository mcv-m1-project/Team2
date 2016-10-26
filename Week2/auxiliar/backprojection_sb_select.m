function params = backprojection_sb_select(min_recall)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab colorspace:

% Loading results:
load('bp_sb_tuning_lab.mat');

max_precision_lab = 0;
nbins_lab_max = 0;
prctile_ths_lab_max = 0;
recall_lab = 0;
for idx1 = 1:length(nbins_vec)
    for idx2 = 1:length(prctile_ths_vec)
        if(recall_array(idx1, idx2) >= min_recall)
            if(precision_array(idx1, idx2) >= max_precision_lab)
                nbins_lab_max = nbins_vec(idx1);
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
fprintf('nbins = %i\n', nbins_lab_max)
fprintf('prctile_ths = %i\n\n', prctile_ths_lab_max)


%%%%%%%%%%%%%%%%%%%%%%%%%
% hsv colorspace:

% Loading results:
load('bp_sb_tuning_hsv.mat');

max_precision_hsv = 0;
nbins_hsv_max = 0;
prctile_ths_hsv_max = 0;
recall_hsv = 0;
for idx1 = 1:length(nbins_vec)
    for idx2 = 1:length(prctile_ths_vec)
        if(recall_array(idx1, idx2) >= min_recall)
            if(precision_array(idx1, idx2) >= max_precision_hsv)
                nbins_hsv_max = nbins_vec(idx1);
                prctile_ths_hsv_max = prctile_ths_vec(idx2);
                max_precision_hsv = precision_array(idx1, idx2);
                recall_hsv = recall_array(idx1, idx2);
            end
        end
    end
end
fprintf('\nMaximum precision found with hsv: %f\n', max_precision_hsv)
fprintf('Recall = %f\n', recall_hsv)
fprintf('Corresponds to the following parameters:\n')
fprintf('nbins = %i\n', nbins_hsv_max)
fprintf('prctile_ths = %i\n\n', prctile_ths_hsv_max)


%%%%%%%%%%%%%%%%%%%%%%%%%
% Selecting colorspace for maximum:
if(max_precision_lab > max_precision_hsv) % Lab wins
    params.colorspace = 'lab';
    params.nbins = nbins_lab_max;
    params.prctile_ths = prctile_ths_lab_max;
    params.r = 5;
    
else % hsv wins
    params.colorspace = 'hsv';
    params.nbins = nbins_hsv_max;
    params.prctile_ths = prctile_ths_hsv_max;
    params.r = 5;
end

% Write results:
save('bp_sb_select.mat', 'params')

return

end


