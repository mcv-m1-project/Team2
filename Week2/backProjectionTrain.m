function [ precisionMat, recallMat, FMat, thMat, bin, th_g1, th_g2, th_g3 ] = backProjectionTrain( dirTrainDataSet, trainSet, signals)
%BACKPROJECTIONTRAIN 
%Funtion to train the color segmentation system based on histogram back-projection
%   Parameters
%       'dirTrainDataSet' - Path to the training set
%       'trainSet' - Vector containing the train set (resulting from the train/validation split) identifiers
%       'signals' - Vector containing the information of all the training
%       traffic signals
%   Returns
%       'precisionMat' - matrix containg the obtained precision depending on
%       the number of bins (rows) and the used threshold (columns)
%       'recallMat' - matrix containg the obtained recall depending on
%       the number of bins (rows) and the used threshold (columns)
%       'bin' - number of bins that maximises the system F-measure
%       'th_g1' - threshold of G1 traffic signals that maximises the system F-measure
%       'th_g2' - threshold of G2 traffic signals that maximises the system F-measure
%       'th_g3' - threshold of G3 traffic signals that maximises the system F-measure

precisionMat = zeros(6,11);
recallMat = zeros(6,11);
thMat = zeros(6,11,3);

numBins = [8 16 32 64 128 256];
for bin=1:length(numBins)
    bin
    [hist_g1,hist_g2,hist_g3] = jointHistogramsByGroup(trainSet, signals, numBins(bin));
    
    max_prob_g1 = max(max(hist_g1));
    max_prob_g2 = max(max(hist_g2));
    max_prob_g3 = max(max(hist_g3));
    
    th_g1=0:(max_prob_g1/10):max_prob_g1;
    th_g2=0:(max_prob_g2/10):max_prob_g2;
    th_g3=0:(max_prob_g3/10):max_prob_g3;
    for th=1:length(th_g1)
        th
        TP = 0;
        FP = 0;
        FN = 0;
        TN = 0;
        
        for image=1:length(trainSet)
            im_orig = imread([dirTrainDataSet '\' trainSet{image} '.jpg']);
            [mask] = maskCalculation(im_orig, hist_g1,hist_g2,hist_g3, th_g1(th), th_g2(th),th_g3(th));
            imGroundTruth = imread([dirTrainDataSet '\mask\mask.' trainSet{image} '.png']);
            [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(mask, imGroundTruth);
            TP = TP + pixelTP;
            FP = FP + pixelFP;
            FN = FN + pixelFN;
            TN = TN + pixelTN;
        end
        
        [precision, accuracy, pixelSpecificity, recall] = PerformanceEvaluationPixel(TP, FP, FN, TN);
        precisionMat(bin,th) = precision;
        recallMat(bin,th) = recall;
        FMat(bin,th) = 2*precision*recall/(precision+recall);
        thMat(bin,th,1) = th_g1(th);
        thMat(bin,th,2) = th_g2(th);
        thMat(bin,th,3) = th_g3(th);
    end
end

plot(precisionMat(1,:),recallMat(1,:),'b.-',precisionMat(2,:),recallMat(2,:),'g.-',precisionMat(3,:),recallMat(3,:),'r.-',precisionMat(4,:),recallMat(4,:),'m.-',precisionMat(5,:),recallMat(5,:),'y.-',precisionMat(6,:),recallMat(6,:),'b.-')
xlabel('Precision')
ylabel('Recall')
legend('8 bins','16 bins','32 bins','64 bins','128 bins','256 bins')

Fmax = max(max(FMat));
[bin_max, th_max] = find(FMat == Fmax);
bin = numBins(bin_max);

th_g1 = thMat(bin_max, th_max,1);
th_g2 = thMat(bin_max, th_max,2);
th_g3 = thMat(bin_max, th_max,3);

[hist_g1,hist_g2,hist_g3] = jointHistogramsByGroup(trainSet, signals, bin);
save('back-projection-Lab', 'hist_g1', 'hist_g2', 'hist_g3', 'th_g1', 'th_g2', 'th_g3');

end

