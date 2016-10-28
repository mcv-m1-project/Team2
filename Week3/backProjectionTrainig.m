function backProjectionTrainig(train_set)
% Find best threshold training with the mask information and HSV color
% space.
% This function generates a file with the results for all the permormed
% combinations of number of bins, threshold and saturation radius.
    %    Parameter name      Value
    %    --------------      -----
    %     train_set          Path to the training set
    
    addpath('..\evaluation\')
    
    files = listFiles(train_set);
    nFiles = size(files, 1);
    
    HISTTrain = fopen('hist_norm_train.txt','w');
    
    n_bins = [16,32,64,128];
    th_eval = 0.001:0.001:0.01;
    sat_radiuses = 0:0.1:1;
    for ri=1:length(th_eval)
        for bi=1:length(n_bins)
            for si=1:length(sat_radiuses)
                bins = n_bins(bi);
                
                load(['red_hist_' num2str(bins) '.mat'])
                load(['blue_hist_' num2str(bins) '.mat'])
                load(['rb_hist_' num2str(bins) '.mat'])

                red_hist(:,1:round(bins * sat_radiuses(si))) = 0;
                blue_hist(:,1:round(bins * sat_radiuses(si))) = 0;
                rb_hist(:,1:round(bins * sat_radiuses(si))) = 0;
                
                fprintf(HISTTrain, 'Training with %f %f %f \n', bins, th_eval(ri), sat_radiuses(si));
                
                pixelTP=0; pixelFN=0; pixelFP=0; pixelTN=0;
                
                %---------- START DATASET -------------
                for i=1:nFiles
                    % Read the image
                    im = imread(strcat(train_set,'/',files(i).name));
                    % Convert the image into HSV
                    im = rgb2hsv(im);

                    % Read the mask image
                    maskGT = imread([train_set, '/mask/mask.',strrep(files(i).name, '.jpg', '.png')]) > 0;

                    maskRes = color_segmentation(im, th_eval(ri), bins, red_hist, blue_hist, rb_hist);
                                        
                    [localPixelTP, localPixelFP, localPixelFN, localPixelTN] = PerformanceAccumulationPixel(maskRes, maskGT);
                    pixelTP = pixelTP + localPixelTP;
                    pixelFP = pixelFP + localPixelFP;
                    pixelFN = pixelFN + localPixelFN;
                    pixelTN = pixelTN + localPixelTN;
                    
                end
                %---------- END DATASET -------------
                
                [pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity] = PerformanceEvaluationPixel(pixelTP, pixelFP, pixelFN, pixelTN);
                pixelF1 = 2 * pixelPrecision * pixelSensitivity / (pixelPrecision + pixelSensitivity);
               
                fprintf(HISTTrain, 'Precision: %f, Accuracy: %f, Specificity: %f, Sensitivity (Recall): %f, F1 score: %f, TP: %f, FP: %f, FN: %f \n', pixelPrecision, pixelAccuracy, pixelSpecificity, pixelSensitivity, pixelF1, pixelTP, pixelFP, pixelFN);
    
            end
        end
    end
    
    fclose(HISTTrain);
end

