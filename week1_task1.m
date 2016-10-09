%%%%% MCV - M1
%%%%% Project - Task 1
%%%%% Xián López Álvarez
%%%%% Creado 06/10/2016
%%%%% Modificado 08/10/2016
%%%%% Recuento de la frecuencia de aparición de cada tipo de señal.


clear all
close all

% Base directory:
dirbase = pwd;

% Directory of the dataset (inside train):
dirdataset = [dirbase, '\..\DataSetDelivered\train'];

% Path to Ground Truth annotations:
dirgt = [dirdataset, '\gt'];

% Path to Masks:
dirmask = [dirdataset, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\evaluation'])

% Create lists with the ground truth annotations files, the mask files, and
% the original image files:
[gt_list, mask_list, images_list] = create_files_list(dirdataset);

% Counting of signals types in annotations in dirgt:
[signals_list, nrepetitions] = count_signals_types(dirgt, gt_list);

% Statistics about form factor:
form_factor = analyze_form_factor(dirgt, gt_list);

% Statistics about filling ratio:
filling_ratio = analyze_filling_ratio(dirgt, gt_list, dirmask, mask_list);

% Names of signals found:
fprintf('Names of signals found:\n')
signals_list

% Times each signal appears:
fprintf('Times each signal appears:\n')
nrepetitions








