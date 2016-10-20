function [nrepetitions, signals, filling_ratio, form_factor] = load_signals(dirTrainDataSet, dirgt, dirmask)

%%%%% MCV - M1
%%%%% Project - Task 1
%%%%% Xián López Álvarez
%%%%% Creado 06/10/2016
%%%%% Modificado 08/10/2016
%%%%% Modificado 10/10/2016
%%%%% Recuento de la frecuencia de aparición de cada tipo de señal.

% Create lists with the ground truth annotations files, the mask files, and
% the original image files:
[gt_list, mask_list, image_list] = ls_create_files_list(dirTrainDataSet);

% We read the dataset, creating a vector of objects with all the
% information about each signal:
signals = ls_create_signal_objects(dirgt, gt_list, dirmask, mask_list, dirTrainDataSet, image_list);

% To handle more easily the filling_ratio and the form_factor, we put them
% in two vectors. By the way, we detect the signals that have no mask.
[filling_ratio, form_factor] = ls_get_fr_ff(signals);

% We just consider the signals which have a well defined mask:
signals = signals(filling_ratio ~= 0);

% See the different types of signals, and count how many times they appear:
[signals_list, nrepetitions] = ls_count_signals_types(signals);

% Again, create vectors with filling_ratio and form_factor.
% This time, we also calculate the means within each type of signal:
[filling_ratio, form_factor, fr_means, ff_means] = ls_get_fr_ff_bytypes(signals, ...
                                                   signals_list, nrepetitions);

% Calculate minimum and maximum size for each type of signal:
[min_size, max_size] = ls_get_min_max_size_bytypes(signals, signals_list, nrepetitions);

save('signals_workspace', 'signals', 'nrepetitions', 'filling_ratio', 'form_factor');

% Summary of signal types:
fprintf('\nSummary of signal types:\n')
fprintf(['type  |  nrep  |  fill ratio  |  form fac', ...
        '  |  min size  |  max size\n'])
for i = 1:length(signals_list)
    fprintf(['  %s       %3i        %5.3f         %5.3f', ...
             '       %6.2f      %7.2f \n'], ...
             signals_list{i}, nrepetitions(i), fr_means(i), ff_means(i), ...
             min_size(i), max_size(i))
end

end


