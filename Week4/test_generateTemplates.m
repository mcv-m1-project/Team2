addpath('..')
addpath('..\evaluation')
load('signals_main_parameters.mat');

dirTrain = [pwd, '\..\..\train'];
inputMasksDir = [dirTrain, '\result_masks\morphological_operators\'];
%Path to the train set truth masks
dirGroundTruthMasks = [dirTrain '\mask'];

%generateTemplates( dirTrain, max_size, ff_means );
%generateTemplates_6types( dirTrain, max_size, ff_means );

[max_corr_up_triangle_hs, max_corr_down_triangle_hs, max_corr_square_hs, max_corr_circle_C_hs, max_corr_circle_D_hs, max_corr_circle_E_hs] = getMaximumCorrelationTrafficSignalTemplates_HSV(dirTrain);
%[max_corr_up_triangle_gray, max_corr_down_triangle_gray, max_corr_square_gray, max_corr_circle_gray] = getMaximumCorrelationTrafficSignalTemplates(dirTrain);
save('trainSetMaxCorrelationValues_HSV', 'max_corr_up_triangle_hs', 'max_corr_down_triangle_hs', 'max_corr_square_hs', 'max_corr_circle_C_hs', 'max_corr_circle_D_hs', 'max_corr_circle_E_hs');


min_corr_up_triangle_h = min(max_corr_up_triangle_hs(1,:));
min_corr_up_triangle_s = min(max_corr_up_triangle_hs(2,:));
min_corr_down_triangle_h = min(max_corr_down_triangle_hs(1,:));
min_corr_down_triangle_s = min(max_corr_down_triangle_hs(2,:));
min_corr_square_h = min(max_corr_square_hs(1,:));
min_corr_square_s = min(max_corr_square_hs(2,:));
min_corr_circle_C_h = min(max_corr_circle_C_hs(1,:));
min_corr_circle_C_s = min(max_corr_circle_C_hs(2,:));
min_corr_circle_D_h = min(max_corr_circle_D_hs(1,:));
min_corr_circle_D_s = min(max_corr_circle_D_hs(2,:));
min_corr_circle_E_h = min(max_corr_circle_E_hs(1,:));
min_corr_circle_E_s = min(max_corr_circle_E_hs(2,:));

