clearvars
close all

% Paths:
addpath('..\')
addpath('..\evaluation')
addpath([pwd, '\..\circular_hough\'])

% Directories:
% dirTestImages = [pwd, '\..\..\train'];
dirTestImages = [pwd, '\..\..\validation'];
inputWindowsDir = [dirTestImages, '\result_masks\CC'];
outputDir = [dirTestImages, '\result_masks\week5_task2_hough_circles'];

% Parameters:
grdthres = 1.5;
fltr4LM_R = 23;
resize = 1;

% List files:
files = listFiles(dirTestImages);
nFiles = length(files);

% Select a random image:
i = floor(rand() * nFiles) + 1;

% File name:
fileId = files(i).name(1:9);

% Load image
im = imread([dirTestImages, '\', files(i).name]);
imshow(im)

% Load window candidates for this image
windowCC = load([inputWindowsDir, '\', fileId, '.mat']);

% Loop over windows:
size_win = size(windowCC.windowCandidates,2);
for idx = 1:size_win
    window = windowCC.windowCandidates(idx);
    x = window.x;
    y = window.y;
    w = window.w;
    h = window.h;

    % Check if the window is empty
    if(x == 0 || y == 0 || w == 0 || h == 0)
        fprintf('Empty window.\n')
        % Do nothing, just go to the next window or image.

    % A window cannot be smaller than 32x32 to perform Hough circle
    % detection.
    elseif(h < 32 || w < 32)
        fprintf('Window too small.\n')
        % Do nothing, just go to the next window or image.

    else
        im_windowed = im(y:y+h-1, x:x+w-1, :);

        % We resize the window to make it squared:
        if(resize)
            im_windowed = imresize(im_windowed, [max(w,h), max(w,h)]);
        end

        im_windowed_gray = rgb2gray(im_windowed);

        minrad = round(min(size(im_windowed,1), size(im_windowed,2)) / 3);
        maxrad = round(min(size(im_windowed,1), size(im_windowed,2)) / 2 * 1.2);

        % Compute the Hough Transform searching for circles:
        % It is important to note that we are feeding this function
        % with the greyscale image, not the edges one. This means the
        % edges we are finding may not be the ones actually used inside
        % the function.
        [accum, circen, cirrad] = CircularHough_Grd(im_windowed_gray, ...
                            [minrad, maxrad], grdthres, fltr4LM_R);

        % Plotting results:
        figure(2);
        imagesc(accum);
        axis image;
        title('Accumulation Array from Circular Hough Transform');

        figure(3);
        imagesc(im_windowed_gray);
        colormap('gray');
        axis image;
        hold on;
        plot(circen(:,1), circen(:,2), 'r+');
        for k = 1 : size(circen, 1),
            DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
        end
        hold off;
        titulo = sprintf('Image %i', i);
        title(titulo);
    end
end


