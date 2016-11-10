    close all,
    addpath('..\')
    addpath('..\evaluation')
    
    %Paths
    dirTestImages = [pwd, '\..\..\train']; 
    inputWindowsDir = [dirTestImages, '\result_masks\CC\']; 
    outputDir = [dirTestImages, '\result_masks\week5_task2_hough_transform\'];
    
    %Final values for maximum angle deviation of quare and triangle signal
    %lines
    delta_theta_90 = 10;
    delta_theta_30 = 5;
    delta_theta_0 = 15;
    
    tic
    houghDetectSignal(dirTestImages, inputWindowsDir, outputDir, delta_theta_90, delta_theta_30, delta_theta_0);
    totalTime = toc;
    time = totalTime/nFiles;
    fprintf('Time: %f',time);