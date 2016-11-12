function select_circles_tuning(min_recall)


% Loading results:
load('results_tune_task2_circles.mat');

max_precision_lab = 0;
grdthres_lab_max = 0;
fltr4LM_R_lab_max = 0;
recall_lab = 0;

for idx1 = 1:length(grdthres_vec)
    for idx2 = 1:length(fltr4LM_R_vec)
        if(recall_array(idx1, idx2) >= min_recall)
            if(precision_array(idx1, idx2) >= max_precision_lab)
                grdthres_lab_max = grdthres_vec(idx1);
                fltr4LM_R_lab_max = fltr4LM_R_vec(idx2);
                max_precision_lab = precision_array(idx1, idx2);
                recall_lab = recall_array(idx1, idx2);
            end
        end
    end
end
fprintf('\nMaximum precision found with lab: %f\n', max_precision_lab)
fprintf('Recall = %f\n', recall_lab)
fprintf('Corresponds to the following parameters:\n')
fprintf('grdthres = %i\n', grdthres_lab_max)
fprintf('fltr4LM_R = %i\n\n', fltr4LM_R_lab_max)



return

end


