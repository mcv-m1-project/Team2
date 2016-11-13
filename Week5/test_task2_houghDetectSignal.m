    close all,
    addpath('..\')
    addpath('..\evaluation')
    
    %Paths
    dirTestImages = [pwd, '\..\..\validation']; 
    inputWindowsDir = [dirTestImages, '\result_masks\CC\']; 
    outputDir = [dirTestImages, '\result_masks\week5_task2_hough_transform\'];
    
    files = ListFiles(dirTestImages);
    nFiles = length(files);
    
    %Final values for maximum angle deviation of quare and triangle signal
    %lines
    delta_theta_90 = 4;
    delta_theta_30 = 8;
    delta_theta_0 = 19;
    grdthres = 1.5;
    fltr4LM_R = 23;
    
    tic
    houghDetectSignal(dirTestImages, inputWindowsDir, outputDir, delta_theta_90, delta_theta_30, delta_theta_0, grdthres, fltr4LM_R);
    totalTime = toc;
    timePerFrame = totalTime/nFiles;
    fprintf('Total time: %f\n Time per frame: %f\n', totalTime, timePerFrame);

    % Evaluate:
    [precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirTestImages, outputDir);
    [precision, recall, accuracy, F1, TP, FN, FP] = pixel_based_evaluation(dirTestImages, outputDir);

    % Evaluation of masks before applying Hough detection:
    [precision, recall, accuracy, F1, TP, FN, FP] = region_based_evaluation(dirTestImages, inputWindowsDir);
    [precision, recall, accuracy, F1, TP, FN, FP] = pixel_based_evaluation(dirTestImages, inputWindowsDir);