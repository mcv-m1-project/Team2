close all,
addpath('..\')
addpath('..\evaluation')

%Paths
dirTestImages = [pwd, '\..\..\train'];
inputWindowsDir = [dirTestImages, '\result_masks\CC\'];
outputDir = [dirTestImages, '\result_masks\week5_task2_hough_transform\'];

files = ListFiles(dirTestImages);
nFiles = length(files);

precisionVec = [];
recallVec = [];
F1Vec = [];
delta_theta_90_vec = [];
delta_theta_30_vec = [];
delta_theta_0_vec = [];
grdthres = 3;
fltr4LM_R = 15;

for delta_theta_90=2:1:8
        for delta_theta_30=2:1:8    
            for delta_theta_0=12:2:24               
                houghDetectSignal(dirTestImages, inputWindowsDir, outputDir, delta_theta_90, delta_theta_30, delta_theta_0, grdthres, fltr4LM_R);
                TP = 0;
                FN = 0;
                FP = 0;
                for i=1:nFiles
                    fileId = files(i).name(1:9);
                    [annotations Signs] = LoadAnnotations([dirTestImages '\gt\gt.' fileId '.txt']);
                    windowCandidates = load([outputDir fileId '.mat']);
                    [localTP,localFN,localFP] = PerformanceAccumulationWindow(windowCandidates.windowCandidates, annotations);
                    TP = TP + localTP;
                    FN = FN + localFN;
                    FP = FP + localFP;
                end
                
                [precision, recall, accuracy] = PerformanceEvaluationWindow(TP, FN, FP);
                F1 = 2*precision*recall/(precision+recall);
                
                precisionVec = [precisionVec precision];
                recallVec = [recallVec recall];
                F1Vec = [F1Vec F1];
                delta_theta_90_vec = [delta_theta_90_vec delta_theta_90];
                delta_theta_30_vec = [delta_theta_30_vec delta_theta_30];
                delta_theta_0_vec = [delta_theta_0_vec delta_theta_0];
                
            end
        end
    end
   
    save('results_train_task2_2', 'precisionVec', 'recallVec', 'F1Vec', 'delta_theta_90_vec', 'delta_theta_30_vec', 'delta_theta_0_vec');