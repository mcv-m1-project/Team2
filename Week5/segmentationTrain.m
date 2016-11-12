function segmentationTrain(dirTrain)
% This code implemented a comparison between “k-means” “mean-shift” and
% “normalized-cut” segmentation

% Teste methods are:
% Kmeans segmentation using (color) only
% Kmeans segmentation using (color + spatial)
% Mean Shift segmentation using (color) only
% Mean Shift segmentation using (color + spatial)
% Normalized Cut (inherently uses spatial data)

% an implementation by "Naotoshi Seo" with a little modification is used 
% for “normalized-cut” segmentation, available online at:
% "http://note.sonots.com/SciSoftware/NcutImageSegmentation.html"
% it is sensitive in choosing parameters.
% an implementation by "Bryan Feldman" is used for “mean-shift clustering" 

% Alireza Asvadi
% Department of ECE, SPR Lab
% Babol (Noshirvani) University of Technology
% http://www.a-asvadi.ir
% 2013
%% clear command windows
% clc
% clear all
% close all

addpath('..\evaluation')
addpath('..')
%% parameters
% kmeans parameter
K    = 100;                  % Cluster Numbers
% meanshift parameter
bw   = 0.2;                % Mean Shift Bandwidth
% ncut parameters
SI   = 5;                  % Color similarity
SX   = 6;                  % Spatial similarity
r    = 1.5;                % Spatial threshold (less than r pixels apart)
sNcut = 0.21;              % The smallest Ncut value (threshold) to keep partitioning
sArea = 80;                % The smallest size of area (threshold) to be accepted as a segment

%evaluation inicialization
TPkm = 0; FPkm = 0; FNkm = 0;
TPkm2 = 0; FPkm2 = 0; FNkm2 = 0;
TPms = 0; FPms = 0; FNms = 0;
TPms2 = 0; FPms2 = 0; FNms2 = 0;

if 2~=exist('segmentation_train.csv','file')
    SegmentationTrain = fopen('segmentation_train.csv','w');
    fprintf(SegmentationTrain, 'Method; Precision; Recall; F1; TP; FN; FP;\n');
else
    SegmentationTrain = fopen('segmentation_train.csv','a');
end
files = ListFiles(dirTrain);
nFiles = length(files);

for img=1:20
    img
    %% input
    fileId = files(img).name(1:9);
    I    = imread([dirTrain '\' fileId '.jpg']);    % Original: also test 2.jpg
    I = imresize(I,0.5);
    % I = rgb2hsv(I);
    %% segmentation
    [Ikm, Lkm, Ckm] = Km(I,K);                     % Kmeans (color)
    [Ikm2, Lkm2, Ckm2] = Km2(I,K);                    % Kmeans (color + spatial)
    [Ims, Nms, Lms, Cms]   = Ms(I,bw);                    % Mean Shift (color)
    [Ims2, Nms2, Lms2, Cms2] = Ms2(I,bw);                   % Mean Shift (color + spatial)
    [Inc, Nnc]   = Nc(I,SI,SX,r,sNcut,sArea);   % Normalized Cut

    %% color decision
    [Mkm] = color_segmentation(Lkm, Ckm);
    Mkm = imresize(logical(Mkm),2);
    [Wkm] = windowFind( Mkm );

    [Mkm2] = color_segmentation(Lkm2, Ckm2);
    Mkm2 = imresize(logical(Mkm2),2);
    [Wkm2] = windowFind( Mkm2 );

    [Mms] = color_segmentation(Lms, Cms);
    Mms = imresize(logical(Mms),2);
    [Wms] = windowFind( Mms );

    [Mms2] = color_segmentation(Lms2, Cms2);
    Mms2 = imresize(logical(Mms2),2);
    [Wms2] = windowFind( Mms2 );
    %% local evaluation
    [annotations , ~] = LoadAnnotations([dirTrain '\gt\gt.' fileId '.txt']);
    [localTPkm, localFNkm, localFPkm] = PerformanceAccumulationWindow(Wkm, annotations);
    TPkm = TPkm + localTPkm;
    FNkm = FNkm + localFNkm;
    FPkm = FPkm + localFPkm;

    [localTPkm2, localFNkm2, localFPkm2] = PerformanceAccumulationWindow(Wkm2, annotations);
    TPkm2 = TPkm2 + localTPkm2;
    FNkm2 = FNkm2 + localFNkm2;
    FPkm2 = FPkm2 + localFPkm2;

    [localTPms, localFNms, localFPms] = PerformanceAccumulationWindow(Wms, annotations);
    TPms = TPms + localTPms;
    FNms = FNms + localFNms;
    FPms = FPms + localFPms;

    [localTPms2, localFNms2, localFPms2] = PerformanceAccumulationWindow(Wms2, annotations);
    TPms2 = TPms2 + localTPms2;
    FNms2 = FNms2 + localFNms2;
    FPms2 = FPms2 + localFPms2;

    %% show
    figure()
    subplot(431); imshow(I);    title('Original'); 
    subplot(432); imshow(Ikm);  title(['Kmeans',' : ',num2str(K)]);
    subplot(433); imshow(Ikm2); title(['Kmeans+Spatial',' : ',num2str(K)]); 
    subplot(434); imshow(Mkm);  title(['Kmeans mask',' : ',num2str(K)]);
    subplot(435); imshow(Mkm2); title(['Kmeans+Spatial mask',' : ',num2str(K)]); 
    subplot(436); imshow(Ims);  title(['MeanShift',' : ',num2str(Nms)]);
    subplot(437); imshow(Mms);  title(['MeanShift mask',' : ',num2str(Nms)]);
    subplot(438); imshow(Ims2); title(['MeanShift+Spatial',' : ',num2str(Nms2)]);
    subplot(439); imshow(Mms2); title(['MeanShift+Spatial mask',' : ',num2str(Nms2)]);
    subplot(236); imshow(Inc);  title(['NormalizedCut',' : ',num2str(Nnc)]); 

end
%% global evaluation
[Pkm, Rkm, ~] = PerformanceEvaluationWindow(TPkm, FNkm, FPkm);
F1km = 2*Pkm*Rkm/(Pkm+Rkm);
fprintf(SegmentationTrain, 'K-means(color) K=%f; %f; %f; %f; %f; %f; %f;\n', K, Pkm, Rkm, F1km, TPkm, FNkm, FPkm);

[Pkm2, Rkm2, ~] = PerformanceEvaluationWindow(TPkm2, FNkm2, FPkm2);
F1km2 = 2*Pkm2*Rkm2/(Pkm2+Rkm2);
fprintf(SegmentationTrain, 'K-means(color + spatial) K=%f; %f; %f; %f; %f; %f; %f;\n', K, Pkm2, Rkm2, F1km2, TPkm2, FNkm2, FPkm2);

[Pms, Rms, ~] = PerformanceEvaluationWindow(TPms, FNms, FPms);
F1ms = 2*Pms*Rms/(Pms+Rms);
fprintf(SegmentationTrain, 'Mean-shift(color) bw=%f N=%f; %f; %f; %f; %f; %f; %f;\n', bw, Nms, Pms, Rms, F1ms, TPms, FNms, FPms);

[Pms2, Rms2, ~] = PerformanceEvaluationWindow(TPms2, FNms2, FPms2);
F1ms2 = 2*Pms2*Rms2/(Pms2+Rms2);
fprintf(SegmentationTrain, 'Mean-shift(color + spatial) bw=%f N=%f; %f; %f; %f; %f; %f; %f;\n', bw, Nms2, Pms2, Rms2, F1ms2, TPms2, FNms2, FPms2);
fclose(SegmentationTrain);
end