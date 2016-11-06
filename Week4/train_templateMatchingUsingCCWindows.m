    close all,
    addpath('..')
    addpath('..\evaluation')
    
    %Paths
    dirTrain = [pwd, '\..\..\train']; 
    inputWindowsDir = [dirTrain, '\result_masks\CC\']; 
    outputDir = [dirTrain, '\result_masks\week4_task1_CC\'];
    
    files = listFiles(dirTrain);
    nFiles = length(files);

    precisionVec = [];
    recallVec = [];
    F1Vec = [];
    up_triangle_th_vec = [];
    down_triangle_th_vec = [];
    square_th_vec = [];
    circle_th_vec = [];
    
    %Get the median and the minimum value of each traffic signal type correlation with
    %its template
    load('trainSetMaxCorrelationValues.mat');
    median_corr_up_triangle_gray = median(max_corr_up_triangle_gray);
    min_corr_up_triangle_gray = min(max_corr_up_triangle_gray);
    
    median_corr_down_triangle_gray = median(max_corr_down_triangle_gray);
    min_corr_down_triangle_gray = min(max_corr_down_triangle_gray);
    
    median_corr_square_gray = median(max_corr_square_gray);
    min_corr_square_gray = min(max_corr_square_gray);
    
    median_corr_circle_gray = median(max_corr_circle_gray);
    min_corr_circle_gray = min(max_corr_circle_gray);
    
    
    for up_triangle_th=linspace(min_corr_up_triangle_gray,median_corr_up_triangle_gray + 0.2, 5) %min_corr_up_triangle_gray:((median_corr_up_triangle_gray + 0.2)-min_corr_up_triangle_gray)/4: median_corr_up_triangle_gray + 0.2
        for down_triangle_th=linspace(min_corr_down_triangle_gray,median_corr_down_triangle_gray + 0.2, 5)               %min_corr_down_triangle_gray:((median_corr_down_triangle_gray + 0.2)-min_corr_down_triangle_gray)/4: median_corr_down_triangle_gray + 0.2
            for circle_th=linspace(min_corr_circle_gray,median_corr_circle_gray + 0.2, 5)                  %min_corr_circle_gray:((median_corr_circle_gray + 0.2)-min_corr_circle_gray)/4: median_corr_circle_gray + 0.2
                for square_th=linspace(min_corr_square_gray,median_corr_square_gray + 0.2, 5)   %min_corr_square_gray:((median_corr_square_gray + 0.2)-min_corr_square_gray)/4: median_corr_square_gray + 0.2
                    
                    templateMatchingUsingCCWindows(dirTrain, inputWindowsDir, outputDir, up_triangle_th, down_triangle_th, circle_th, square_th);
                    
                            TP = 0;
                            FN = 0;
                            FP = 0;
                            for i=1:nFiles
                                fileId = files(i).name(1:9);
                                [annotations Signs] = LoadAnnotations([dirTrain '\gt\gt.' fileId '.txt']);
                                windowsSelected = load([outputDir fileId '.mat']);
                                [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowsSelected.windowsSelected, annotations);
                                TP = TP + localTP;
                                FN = FN + localFN;
                                FP = FP + localFP;
                            end
    
                            [precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
                            F1 = 2*precision*recall/(precision+recall);
                            
                            precisionVec = [precisionVec precision];
                            recallVec = [recallVec recall];
                            F1Vec = [F1Vec F1];                    
                            up_triangle_th_vec = [up_triangle_th_vec up_triangle_th];
                            down_triangle_th_vec = [down_triangle_th_vec down_triangle_th];
                            square_th_vec = [square_th_vec square_th];
                            circle_th_vec  = [circle_th_vec circle_th];
                            
                    
                end
            end
        end
    end
   
    save('results_train_TemplateCC', 'precisionVec', 'recallVec', 'F1Vec', 'up_triangle_th_vec', 'down_triangle_th_vec', 'square_th_vec', 'circle_th_vec');
    