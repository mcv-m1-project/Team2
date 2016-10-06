%%%%% MCV - M1
%%%%% Project - Task 1
%%%%% Xián López Álvarez
%%%%% 06/10/2016
%%%%% Recuento de la frecuencia de aparición de cada tipo de señal.



clear all
close all

% We add the path where some scripts are.
addpath('C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\Team2\evaluation')

% Base directory:
dirbase = pwd;

% Path to Ground Truth annotations:
dirgt = [pwd, '\..\DataSetDelivered\train\gt'];

% Counting of signals types in annotations in dirgt:
[signals_list, nrepetitions] = count_signals_types(dirgt);

% Names of signals found:
fprintf('Names of signals found:\n')
signals_list

% Times each signal appear:
fprintf('Times each signal appear:\n')
nrepetitions









