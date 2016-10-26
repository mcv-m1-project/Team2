function [precision_array, recall_array] = tune_sb(train_signals, trainSet, validationSet, dirimage, ...
                                            dirmask, colorspace, nbins_vec, thresholds_vec, r_vec)


% Start counting time:
tic

% Reading validation masks and images:
nvalidation = length(validationSet);
validation_images = cell(1, nvalidation);
validation_masks = cell(1, nvalidation);
for i = 1:nvalidation
    imagefile = [dirimage, '\', validationSet{i}, '.jpg'];
    validation_images{i} = imread(imagefile);
    maskfile = [dirmask, '\mask.', validationSet{i}, '.png'];
    validation_masks{i} = imread(maskfile);
end

% Create matrices with pixels in and outside train signals:
[Xin, ~] = create_Xin_Xout(train_signals, trainSet, dirimage, dirmask);

len_nbins = length(nbins_vec);
len_thresholds = length(thresholds_vec);
len_r = length(r_vec);

% Arrays of evaluation results:
precision_array = zeros(len_nbins, len_thresholds, len_r);
recall_array = zeros(len_nbins, len_thresholds, len_r);

for idx1 = 1:len_nbins
    nbins = nbins_vec(idx1);
    for idx2 = 1:len_thresholds
        threshold = thresholds_vec(idx2);
        for idx3 = 1:len_r
            r = r_vec(idx3);
            
            % Display progess information:
            fprintf('\n (%i/%i) nbins = %i\n (%i/%i) threshold = %f\n', ...
                idx1, len_nbins, nbins, idx2, len_thresholds, threshold)
            fprintf('(%i/%i) r = %f\n', ...
                idx3, len_r, r)

            % Grids:
            [gridx, gridy] = histograms_create_grids(nbins, colorspace);

            % Training backprojection:
            M = backprojection_sb_train(gridx, gridy, colorspace, Xin, 0);

            % Loop over validation images:
            TPacum = 0;
            FPacum = 0;
            FNacum = 0;
            TNacum = 0;
            fprintf('\nComputing precision and recall...\n')
            progress = 10;
            fprintf('Completado 0%%\n')
            for i = 1:nvalidation
                if(i > progress / 100 * nvalidation)
                    fprintf('Completado %i%%\n', progress)
                    progress = progress + 10;
                end
                % Computed mask:
                computed_mask = backprojection_sb_run(validation_images{i}, M, ...
                                    gridx, gridy, colorspace, r, threshold, 0, 0);
                % Performance evaluation:
                [TP, FP, FN, TN] = PerformanceAccumulationPixel(computed_mask, validation_masks{i});
                TPacum = TPacum + TP;
                FPacum = FPacum + FP;
                FNacum = FNacum + FN;
                TNacum = TNacum + TN;
            end
            fprintf('Completado 100%%\n\n')

            % Computing statistics:
            % Precision:
            precision_array(idx1, idx2, idx3) = TPacum / (TPacum + FPacum);
            % Recall:
            recall_array(idx1, idx2, idx3) = TPacum / (TPacum + FNacum);
        end
    end
end

time = toc;
fprintf('\n Tuning sweep complete. Time taken: %f\n', time)
fprintf('Time per combination: %f\n', time / (len_nbins * len_thresholds * len_r))

return

end