function [precision, accuracy, recall, F1, TP, FP, FN, tpf] = ...
    validation_mod2_3groups(validationSet, dirimage, dirmask, params)


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

% Start counting time:
tic

% Loop over validation images:
TP = 0;
FP = 0;
FN = 0;
TN = 0;
fprintf('\nComputing efficiency measures...\n')
progress = 10;
fprintf('Completado 0%%\n')
for i = 1:nvalidation
    if(i > progress / 100 * nvalidation)
        fprintf('Completado %i%%\n', progress)
        progress = progress + 10;
    end
    
    % Computed mask:
    computed_mask = run_mod2_3groups(validation_images{i}, params);
                    
    % Performance evaluation:
    [TPimage, FPimage, FNimage, TNimage] = PerformanceAccumulationPixel(computed_mask, validation_masks{i});
    TP = TP + TPimage;
    FP = FP + FPimage;
    FN = FN + FNimage;
    TN = TN + TNimage;
end
fprintf('Completado 100%%\n')

precision = TP / (TP + FP);
recall = TP / (TP + FN);
accuracy = (TP + TN) / (TP + TN + FP + FN);
F1 = 2 * TP / (2 * TP + FP + FN);

time = toc;
tpf = time / nvalidation;
fprintf('Time taken: %f\n', time)
fprintf('Time per frame %f\n\n', tpf)

return

end