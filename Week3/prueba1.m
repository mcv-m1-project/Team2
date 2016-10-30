clear all
close all

ni=8;
nj=10;

maskin = zeros(ni,nj);
for i = 1:ni
    for j = 1:nj
        maskin(i,j) = round(rand());
    end
end

II = cumsum(cumsum(double(maskin)),2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

im = imread('C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\mask\mask.00.001527.png');
im = imread('C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\mask\mask.00.001528.png');
im = imread('C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\mask\mask.00.004883.png');
im = imread('C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\mask\mask.00.005176.png');
im = imread('C:\Users\Xian\Documents\MCV\M1_IHCV\Proxecto\train\mask\mask.00.005294.png');
width = 20;
height = 20;
stepW = 10;
stepH = 10;

[masknormal, windowCandidatesnormal] = slidingWindowImage(im, width, height, stepW, stepH);

% [maskintegral, windowCandidatesintegral] = slidingWindowIntegralImage(im, width, height, stepW, stepH);
[maskintegral, windowCandidatesintegral] = slidingWindowConvolution(im, width, height, stepW, stepH);

sum(sum(abs(masknormal-maskintegral)))





