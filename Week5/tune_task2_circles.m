clearvars
close all

addpath('..\')
addpath('..\evaluation')
addpath([pwd, '\..\circular_hough\'])

%Paths
dirTestImages = [pwd, '\..\..\train_circular'];
inputWindowsDir = [dirTestImages, '\result_masks\CC'];
outputDir = [dirTestImages, '\result_masks\week5_task2_hough_circles'];

files = ListFiles(dirTestImages);
nFiles = length(files);

grdthres_vec = [1, 1.5, 2, 2.5, 3, 4, 5, 7.5, 10];
fltr4LM_R_vec = [5, 10, 15, 18, 20, 22, 25, 30];

% grdthres_vec = [1.5, 2];
% fltr4LM_R_vec = [20, 22];

precision_array = zeros(length(grdthres_vec), length(fltr4LM_R_vec));
recall_array = zeros(length(grdthres_vec), length(fltr4LM_R_vec));
F1_array = zeros(length(grdthres_vec), length(fltr4LM_R_vec));

for idx1 = 1:length(grdthres_vec)
    grdthres = grdthres_vec(idx1);
    
    for idx2 = 1:length(fltr4LM_R_vec)    
        fltr4LM_R = fltr4LM_R_vec(idx2);

        % Display progess information:
        fprintf('\n(%i/%i) grdthres = %i\n(%i/%i) fltr4LM_R = %i\n', ...
            idx1, length(grdthres_vec), grdthres, idx2, length(fltr4LM_R_vec), fltr4LM_R)

        task2_circles(dirTestImages, inputWindowsDir, outputDir, grdthres, fltr4LM_R, 1)
        
        [precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirTestImages, outputDir);

        precision_array(idx1, idx2) = precision;
        recall_array(idx1, idx2) = recall;
        F1_array(idx1, idx2) = F1;
    end
end

save('results_tune_task2_circles', 'precision_array', 'recall_array', 'F1_array', 'grdthres_vec', 'fltr4LM_R_vec');