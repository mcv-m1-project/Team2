clearvars
close all

addpath([pwd, '\..\circular_hough\'])


%%
%%%%%%%% EXAMPLE #0:
rawimg = imread('TestImg_CHT_a2.bmp');
tic;
[accum, circen, cirrad] = CircularHough_Grd(rawimg, [15 60]);
toc;
figure(1); imagesc(accum); axis image;
title('Accumulation Array from Circular Hough Transform');
figure(2); imagesc(rawimg); colormap('gray'); axis image;
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
end
hold off;
title(['Raw Image with Circles Detected ', ...
    '(center positions and radii marked)']);
figure(3); surf(accum, 'EdgeColor', 'none'); axis ij;
title('3-D View of the Accumulation Array');
% COMMENTS ON EXAMPLE #0:
% Kind of an easy case to handle. To detect circles in the image whose
% radii range from 15 to 60. Default values for arguments 'grdthres',
% 'fltr4LM_R', 'multirad' and 'fltr4accum' are used.

%%
%%%%%%%% EXAMPLE #1:
rawimg = imread('TestImg_CHT_a3.bmp');
tic;
[accum, circen, cirrad] = CircularHough_Grd(rawimg, [15 60], 10, 20);
toc;
figure(1); imagesc(accum); axis image;
title('Accumulation Array from Circular Hough Transform');
figure(2); imagesc(rawimg); colormap('gray'); axis image;
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
end
hold off;
title(['Raw Image with Circles Detected ', ...
     '(center positions and radii marked)']);
figure(3); surf(accum, 'EdgeColor', 'none'); axis ij;
title('3-D View of the Accumulation Array');

% COMMENTS ON EXAMPLE #1:
% The shapes in the raw image are not very good circles. As a result,
% the profile of the peaks in the accumulation array are kind of
% 'stumpy', which can be seen clearly from the 3-D view of the
% accumulation array. (As a comparison, please see the sharp peaks in
% the accumulation array in example #0) To extract the peak positions
% nicely, a value of 20 (default is 8) is used for argument 'fltr4LM_R',
% which is the radius of the filter used in the search of peaks.

%%
%%%%%%%% EXAMPLE #2:
rawimg = imread('TestImg_CHT_b3.bmp');
fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
fltr4img = fltr4img / sum(fltr4img(:));
imgfltrd = filter2( fltr4img , rawimg );
tic;
[accum, circen, cirrad] = CircularHough_Grd(imgfltrd, [15 80], 8, 10);
toc;
figure(1); imagesc(accum); axis image;
title('Accumulation Array from Circular Hough Transform');
figure(2); imagesc(rawimg); colormap('gray'); axis image;
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
end
hold off;
title(['Raw Image with Circles Detected ', ...
    '(center positions and radii marked)']);

% COMMENTS ON EXAMPLE #2:
% The circles in the raw image have small scale irregularities along
% the edges, which could lead to an accumulation array that is bad for
% local maxima detection. A 5-by-5 filter is used to smooth out the
% small scale irregularities. A blurred image is actually good for the
% algorithm implemented here which is based on the image's gradient
% field.

%%
%%%%%%%% EXAMPLE #3:
rawimg = imread('TestImg_CHT_c3.bmp');
fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
fltr4img = fltr4img / sum(fltr4img(:));
imgfltrd = filter2( fltr4img , rawimg );
tic;
[accum, circen, cirrad] = ...
    CircularHough_Grd(imgfltrd, [15 105], 8, 10, 0.7);
toc;
figure(1); imagesc(accum); axis image;
figure(2); imagesc(rawimg); colormap('gray'); axis image;
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for k = 1 : size(circen, 1),
    DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
end
hold off;
title(['Raw Image with Circles Detected ', ...
    '(center positions and radii marked)']);

% COMMENTS ON EXAMPLE #3:
% Similar to example #2, a filtering before circle detection works for
% noisy image too. 'multirad' is set to 0.7 to eliminate the false
% detections of the circles' radii.