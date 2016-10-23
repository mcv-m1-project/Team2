function backProjectionTest( dirTestDataSet)
%BACKPROJECTIONTEST
%Funtion that applys histogram back-projection to obtain the traffic signal masks
%   Parameters
%       'dirTestDataSet' - Path to the training set
%       'testSet' - Vector containing the validation set (resulting from the train/validation split) identifiers

hist = load('back-projection-Lab');
hist_g1 = hist.hist_g1;
hist_g2 = hist.hist_g2;
hist_g3 = hist.hist_g3;

max_prob_g1 = max(max(hist_g1));
max_prob_g2 = max(max(hist_g2));
max_prob_g3 = max(max(hist_g3));

th_g1=hist.th_g1;
th_g2=hist.th_g2;
th_g3=hist.th_g3;

testSet = dir(dirTestDataSet);
for image=3:length(testSet)
	im_orig = imread([dirTestDataSet '\' testSet(image).name]);
	[mask] = maskCalculation(im_orig, hist_g1,hist_g2,hist_g3, th_g1, th_g2,th_g3);
	imwrite(mask,[dirTestDataSet '\result_masks\back-projection\validation\' testSet(image).name(1:9) '.png']);
end

end

