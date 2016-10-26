%%%%%%%%%%%%%%%%%%%%%%%%%
%%% *****

clear all
close all

% Base path:
dirbase = pwd;
% Path do data set:
dirimage = [dirbase, '\..\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirimage, '\gt'];
% Path to Masks:
dirmask = [dirimage, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\..\evaluation\'])
addpath([dirbase, '\auxiliar\'])

% Load signals vector.
load('signals_workspace');

% Train / validation split:
[trainSet, validationSet] = train_validation_split(dirimage, nrepetitions);

% Creating validation files lists:
nvalidation = length(validationSet);
validation_image_list = cell(1, nvalidation);
validation_mask_list = cell(1, nvalidation);
for i = 1:nvalidation
    validation_image_list{i} = [validationSet{i}, '.jpg'];
    validation_mask_list{i} = ['\mask.', validationSet{i}, '.png'];
end

% Create validation signals vector, separeted by group:
countABC = 0;
countDF = 0;
countE = 0;
for i = 1:length(signals)
    tag = 0;
    % We check if this signal belongs to the training set:
    for j = 1:length(validationSet)
        if(~isempty(strfind(signals(i).filename, validationSet{j})))
            tag = 1;
            break
        end
    end
    if(tag == 1)
        % Switch depending on signal type:
        switch signals(i).type
            case {'A', 'B', 'C'}
                countABC = countABC + 1;
                validation_signalsABC(countABC) = signals(i);
                
            case {'D', 'F'}
                countDF = countDF + 1;
                validation_signalsDF(countDF) = signals(i);
                
            case 'E'
                countE = countE + 1;
                validation_signalsE(countE) = signals(i);
                
            otherwise
                error('Signal type not recognized')
        end
    end
end

% Separating images and masks lists:

% ABC
validation_mask_list_ABC = cell(0);
validation_image_list_ABC = cell(0);
countABC = 0;
for i = 1:length(validation_signalsABC)
    % Check if the filename is already in the list:
    flag = 0;
    for j = 1:length(validation_image_list_ABC)
        if(~isempty(strfind(validation_image_list_ABC{j}, validation_signalsABC(i).filename)))
            flag = 1;
            break
        end
    end
    if(flag == 0)
        countABC = countABC + 1;
        validation_image_list_ABC{countABC} = [validation_signalsABC(i).filename, '.jpg'];
        validation_mask_list_ABC{countABC} = ['mask.', validation_signalsABC(i).filename, '.png'];
    end
end

% DF
validation_mask_list_DF = cell(0);
validation_image_list_DF = cell(0);
countDF = 0;
for i = 1:length(validation_signalsDF)
    % Check if the filename is already in the list:
    flag = 0;
    for j = 1:length(validation_image_list_DF)
        if(~isempty(strfind(validation_image_list_DF{j}, validation_signalsDF(i).filename)))
            flag = 1;
            break
        end
    end
    if(flag == 0)
        countDF = countDF + 1;
        validation_image_list_DF{countDF} = [validation_signalsDF(i).filename, '.jpg'];
        validation_mask_list_DF{countDF} = ['mask.', validation_signalsDF(i).filename, '.png'];
    end
end

% E
validation_mask_list_E = cell(0);
validation_image_list_E = cell(0);
countE = 0;
for i = 1:length(validation_signalsE)
    % Check if the filename is already in the list:
    flag = 0;
    for j = 1:length(validation_image_list_E)
        if(~isempty(strfind(validation_image_list_E{j}, validation_signalsE(i).filename)))
            flag = 1;
            break
        end
    end
    if(flag == 0)
        countE = countE + 1;
        validation_image_list_E{countE} = [validation_signalsE(i).filename, '.jpg'];
        validation_mask_list_E{countE} = ['mask.', validation_signalsE(i).filename, '.png'];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRAINING

% % Minimum recall:
% min_recall = 0.5;
% 
% % Selecting parameters and training all methods with ABC images:
% bp_select_minrecall(min_recall, train_signalsABC, train_image_list_ABC, dirimage, train_mask_list_ABC, dirmask)
% load('bp_sb_final.mat')
% save('bp_sb_final_ABC.mat', 'M', 'gridx', 'gridy', 'colorspace', 'prctile_ths', 'r')
% load('bp_mod_final.mat')
% save('bp_mod_final_ABC.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')
% load('bp_kde_final.mat')
% save('bp_kde_final_ABC.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')
% 
% % Selecting parameters and training all methods with DF images:
% bp_select_minrecall(min_recall, train_signalsDF, train_image_list_DF, dirimage, train_mask_list_DF, dirmask)
% load('bp_sb_final.mat')
% save('bp_sb_final_DF.mat', 'M', 'gridx', 'gridy', 'colorspace', 'prctile_ths', 'r')
% load('bp_mod_final.mat')
% save('bp_mod_final_DF.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')
% load('bp_kde_final.mat')
% save('bp_kde_final_DF.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')
% 
% % Selecting parameters and training all methods with E images:
% bp_select_minrecall(min_recall, train_signalsE, train_image_list_E, dirimage, train_mask_list_E, dirmask)
% load('bp_sb_final.mat')
% save('bp_sb_final_E.mat', 'M', 'gridx', 'gridy', 'colorspace', 'prctile_ths', 'r')
% load('bp_mod_final.mat')
% save('bp_mod_final_E.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')
% load('bp_kde_final.mat')
% save('bp_kde_final_E.mat', 'R', 'gridx', 'gridy', 'colorspace', 'prctile_ths')
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTING AND WRITING MASKS

% Create directories:
dirmaskwrite_sb = [dirimage, '\result_masks\bp_sb'];
dirmaskwrite_mod = [dirimage, '\result_masks\bp_mod'];
dirmaskwrite_kde = [dirimage, '\result_masks\bp_kde'];
mkdir(dirmaskwrite_sb)
mkdir(dirmaskwrite_mod)
mkdir(dirmaskwrite_kde)

% Masks:
fprintf('\nComputing and writing test masks...\n')
progress = 10;
fprintf('Completado 0%%\n')
len_validationSet = length(validation_image_list);
for i = 1:len_validationSet
    if(i > progress / 100 * len_validationSet)
        fprintf('Completado %i%%\n', progress)
        progress = progress + 10;
    end
    
    imagename = validation_image_list{i};
    simplename = imagename(1:(regexp(imagename, '\.jpg$')-1));
    imagefile = [dirimage, '\', imagename];
    image = imread(imagefile);
    
    %%%% Swain-Ballard %%%
    % ABC
    load('bp_sb_final_ABC.mat')
    maskABC = backprojection_sb_run(image, M, gridx, gridy, colorspace, r, prctile_ths);
    % DF
    load('bp_sb_final_DF.mat')
    maskDF = backprojection_sb_run(image, M, gridx, gridy, colorspace, r, prctile_ths);
    % E
    load('bp_sb_final_E.mat')
    maskE = backprojection_sb_run(image, M, gridx, gridy, colorspace, r, prctile_ths);
    % Joining them:
    mask_sb = maskABC | maskDF | maskE;
    % Writing mask:
    imwrite(mask_sb, [dirmaskwrite_sb, '\mask.', simplename, '.png'])
    
    %%%% Modified %%%
    % ABC
    load('bp_mod_final_ABC.mat')
    maskABC = backprojection_mod_run(image, R, gridx, gridy, colorspace, prctile_ths);
    % DF
    load('bp_mod_final_DF.mat')
    maskDF = backprojection_mod_run(image, R, gridx, gridy, colorspace, prctile_ths);
    % E
    load('bp_mod_final_E.mat')
    maskE = backprojection_mod_run(image, R, gridx, gridy, colorspace, prctile_ths);
    % Joining them:
    mask_mod = maskABC | maskDF | maskE;
    % Writing mask:
    imwrite(mask_mod, [dirmaskwrite_mod, '\mask.', simplename, '.png'])
    
    %%%% KDE %%%
    % ABC
    load('bp_kde_final_ABC.mat')
    maskABC = backprojection_kde_run(image, R, gridx, gridy, colorspace, prctile_ths);
    % DF
    load('bp_kde_final_DF.mat')
    maskDF = backprojection_kde_run(image, R, gridx, gridy, colorspace, prctile_ths);
    % E
    load('bp_kde_final_E.mat')
    maskE = backprojection_kde_run(image, R, gridx, gridy, colorspace, prctile_ths);
    % Joining them:
    mask_kde = maskABC | maskDF | maskE;
    % Writing mask:
    imwrite(mask_kde, [dirmaskwrite_kde, '\mask.', simplename, '.png'])
    
end
fprintf('Completado 100%%\n\n')







