%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pruebas
%%% Xián López Álvarez

clear all
close all




% Base path:
dirbase = pwd;
% Path do data set:
dirTrainDataSet = [dirbase, '\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirTrainDataSet, '\gt'];
% Path to Masks:
dirmask = [dirTrainDataSet, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\evaluation\'])
addpath([dirbase, '\colorspace\'])


[nrepetitions, signals, filling_ratio, form_factor] = load_signals(dirTrainDataSet, dirgt, dirmask);






