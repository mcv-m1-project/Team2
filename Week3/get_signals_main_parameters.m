function [signals, signals_list, nrepetitions, min_size, max_size, form_factor, filling_ratio, fr_means, ff_means] = get_signals_main_parameters(dirTrainDataSet, dirgt, dirmask)

% Create lists with the ground truth annotations files, the mask files, and
% the original image files:
[gt_list, mask_list, image_list] = create_files_list(dirTrainDataSet);

% We read the dataset, creating a vector of objects with all the
% information about each signal:
signals = create_signal_objects(dirgt, gt_list, dirmask, mask_list, dirTrainDataSet, image_list);

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

% Calculate minimum and maximum size for each type of signal:
[min_size, max_size] = get_min_max_size_bytypes(signals, signals_list, nrepetitions);

save('signals_main_parameters', 'signals', 'signals_list', 'nrepetitions', 'fr_means', 'ff_means', 'min_size', 'max_size', 'form_factor', 'filling_ratio');

end


