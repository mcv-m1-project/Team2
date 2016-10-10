%%%%% MCV - M1
%%%%% Project - Task 1
%%%%% Xián López Álvarez
%%%%% Creado 06/10/2016
%%%%% Modificado 08/10/2016
%%%%% Modificado 10/10/2016
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
[gt_list, mask_list, image_list] = create_files_list(dirdataset);

% We read the dataset, creating a vector of objects with all the
% information about each signal:
signals = create_signal_objects(dirgt, gt_list, dirmask, mask_list, dirdataset, image_list);

% To handle more easily the filling_ratio and the form_factor, we put them
% in two vectors. By the way, we detect the signals that have no mask.
[filling_ratio, form_factor] = get_fr_ff(signals);

% We just consider the signals which have a well defined mask:
signals = signals(filling_ratio ~= 0);

% See the different types of signals, and count how many times they appear:
[signals_list, nrepetitions] = count_signals_types(signals);

% Again, create vectors with filling_ratio and form_factor.
% This time, we also calculate the means within each type of signal:
[filling_ratio, form_factor, fr_means, ff_means] = get_fr_ff_bytypes(signals, ...
                                                   signals_list, nrepetitions);

% Summary of signal types:
fprintf('\nSummary of signal types:\n')
fprintf('signal type  |  nrepetitions  |  filling ratio  |  form factor\n')
for i = 1:length(signals_list)
    fprintf('     %s               %3i             %5.3f            %5.3f \n', ...
        signals_list{i}, nrepetitions(i), fr_means(i), ff_means(i))
end


% Information about signal #46:
fprintf('\nInformation about signal 46:\n')
fprintf('Signal(46) type: %s.\n', signals(46).type)
fprintf('Signal(46) filling ratio: %f.\n', signals(46).filling_ratio)
fprintf('Signal(46) form factor: %f.\n', signals(46).form_factor)
fprintf('Signal(46), defined in file: %s.\n', signals(46).filename)
fprintf('Signal(46), position in the file: %i.\n', signals(46).nos_infile)



% Images:
figure()
subplot(4,4,1)
imshow(signals(1).image)
subplot(4,4,2)
imshow(signals(2).image)
subplot(4,4,3)
imshow(signals(3).image)
subplot(4,4,4)
imshow(signals(4).image)
subplot(4,4,5)
imshow(signals(5).image)
subplot(4,4,6)
imshow(signals(6).image)
subplot(4,4,7)
imshow(signals(7).image)
subplot(4,4,8)
imshow(signals(8).image)
subplot(4,4,9)
imshow(signals(9).image)
subplot(4,4,10)
imshow(signals(10).image)
subplot(4,4,11)
imshow(signals(11).image)
subplot(4,4,12)
imshow(signals(12).image)
subplot(4,4,13)
imshow(signals(13).image)
subplot(4,4,14)
imshow(signals(14).image)
subplot(4,4,15)
imshow(signals(15).image)
subplot(4,4,16)
imshow(signals(16).image)


% Masks:
figure()
subplot(4,4,1)
imshow(signals(1).mask, [0, 1])
subplot(4,4,2)
imshow(signals(2).mask, [0, 1])
subplot(4,4,3)
imshow(signals(3).mask, [0, 1])
subplot(4,4,4)
imshow(signals(4).mask, [0, 1])
subplot(4,4,5)
imshow(signals(5).mask, [0, 1])
subplot(4,4,6)
imshow(signals(6).mask, [0, 1])
subplot(4,4,7)
imshow(signals(7).mask, [0, 1])
subplot(4,4,8)
imshow(signals(8).mask, [0, 1])
subplot(4,4,9)
imshow(signals(9).mask, [0, 1])
subplot(4,4,10)
imshow(signals(10).mask, [0, 1])
subplot(4,4,11)
imshow(signals(11).mask, [0, 1])
subplot(4,4,12)
imshow(signals(12).mask, [0, 1])
subplot(4,4,13)
imshow(signals(13).mask, [0, 1])
subplot(4,4,14)
imshow(signals(14).mask, [0, 1])
subplot(4,4,15)
imshow(signals(15).mask, [0, 1])
subplot(4,4,16)
imshow(signals(16).mask, [0, 1])




