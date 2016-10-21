function params = backprojection_kde_select2(min_recall)


%%%%%%%%%%%%%%%%%%%%%%%%%
% hsv colorspace:

% Loading results:
load('bp_kde_tuning_hsv.mat');

max_precision_hsv = 0;
nbins_hsv_max = 0;
h_hsv_max = 0;
r_hsv_max = 0;
prctile_ths_hsv_max = 0;
for idx1 = 1:length(nbins_vec)
    for idx2 = 1:length(h_vec)
        for idx3 = 1:length(r_vec)
            for idx4 = 1:length(prctile_ths_vec)
                if(recall_array(idx1, idx2, idx3, idx4) >= min_recall)
                    if(precision_array(idx1, idx2, idx3, idx4) >= max_precision_hsv)
                        nbins_hsv_max = nbins_vec(idx1);
                        h_hsv_max = h_vec(idx2);
                        r_hsv_max = r_vec(idx3);
                        prctile_ths_hsv_max = prctile_ths_vec(idx4);
                        max_precision_hsv = precision_array(idx1, idx2, idx3, idx4);
                        recall_hsv = recall_array(idx1, idx2, idx3, idx4);
                    end
                end
            end
        end
    end
end
fprintf('Maximum precision found with hsv: %f\n', max_precision_hsv)
fprintf('Recall = %f\n', recall_hsv)
fprintf('Corresponds to the following parameters:\n')
fprintf('nbins = %i\n', nbins_hsv_max)
fprintf('h = %i\n', h_hsv_max)
fprintf('r = %i\n', r_hsv_max)
fprintf('prctile_ths = %i\n\n', prctile_ths_hsv_max)


%%%%%%%%%%%%%%%%%%%%%%%%%
params.colorspace = 'hsv';
params.nbins = nbins_hsv_max;
params.h = h_hsv_max;
params.r = r_hsv_max;
params.prctile_ths = prctile_ths_hsv_max;


