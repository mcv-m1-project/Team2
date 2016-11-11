clearvars
close all


addpath('..\')
addpath('..\evaluation')
addpath([pwd, '\..\circular_hough\'])
    
%Paths
dirTestImages = [pwd, '\..\..\train']; 
inputWindowsDir = [dirTestImages, '\result_masks\CC\']; 
outputDir = [dirTestImages, '\result_masks\week5_task2_hough_circles\'];

files = ListFiles(dirTestImages);
nFiles = length(files);

if(7~=exist(outputDir,'dir'))
    mkdir(outputDir);
end

% Load the informatino from the signals to get the minimum and maximum
% % radius:
% load('signals_main_parameters.mat');
% % We only consider the circular signals (C, D and E):
% minSize = min(min_size([3, 4, 5]));
% maxSize = max(max_size([3, 4, 5]));
% % We don't consider the form factor; circular signals can be supposed to
% % have a square bounding box.
% minrad = sqrt(minSize) / 2;
% maxrad = sqrt(maxSize) / 2;

files = ListFiles(dirTestImages);
nFiles = length(files);

% Parameters for Hough circles function.
% The less sharp the accumulation array is, the bigger this paramter must
% be.
fltr4LM_R = 8;
% Threshold for edges detection. Expressed on percentage over maximum grey
% level.
percen_grdthres = 0.05;

% i = 1;

% i = 8;
% i = 9;
% i = 31;
i = 35;
% i = 39;
% i = 88;
% i = 90;
% i = 91;
% i = 175;
% i = 195;
% i = 229;
% i = 239;
% i = 247;
% i_circles = [8, 9, 31, 39, 88, 90, 91, 175, 195, 229, 239, 247];
% n = floor(rand() * length(i_circles)) + 1;
% i = i_circles(n);

% i = floor(rand() * nFiles) + 1;

% for i = 1:nFiles
    fileId = files(i).name(1:9);
    windowCandidates = [];
    % Load image
    im = imread([dirTestImages, '\', files(i).name]);
    mask = imread([inputWindowsDir, fileId, '.png']);
    
    % Initializing output mask:
    out_mask = im(:,:,1).*0;
    
    % Load window candidates for this image
    windowCC = load([inputWindowsDir fileId '.mat']);
    window = windowCC.windowCandidates(1);
    
    % Check if the window is empty
    if(window.w == 0 || ...
       window.y == 0 || ...
       window.w == 0 || ...
       window.h == 0)
        windowCandidates = [windowCandidates ; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        
    % A window cannot be smaller than 32x32 to perform Hough circle
    % detection.
    elseif(window.h < 32 || window.w < 32)
        windowCandidates = [windowCandidates ; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        
    else
        size_win = size(windowCC.windowCandidates,2);
        for idx = 1:size_win
            window = windowCC.windowCandidates(idx);
            x = window.x;
            y = window.y;
            w = window.w;
            h = window.h;
            im_windowed = im(y:y+h-1, x:x+w-1, :);
%             im_windowed = int16(im(y:y+h-1, x:x+w-1, :));
%             im_windowed2 = imcrop(im, [window.x+1, window.y+1, window.w-1, window.h-1]);
            
            % We resize the window to make it squared:
            im_windowed = imresize(im_windowed, [max(w,h), max(w,h)]);
            
            im_windowed_gray = rgb2gray(im_windowed);
%             im_windowed_gray = (im_windowed(:,:,1) + im_windowed(:,:,2)+ im_windowed(:,:,3)) / 3;
            mask_windowed = mask(y:y+h-1, x:x+w-1, :);
            
            % Computing edges:
            %mask_edges = edge(mask_windowed, 'canny', threshold_canny, sigma);
            mask_edges = edge(mask_windowed, 'canny');
            im_edges = edge(im_windowed_gray, 'canny');

            figure(1)
            subplot(2,2,1), imshow(im_windowed_gray)
            titulo = sprintf('File %i: %s', i, fileId);
            subplot(2,2,2), imshow(mask_windowed, [0,1])
            subplot(2,2,3), imshow(mask_edges)
            subplot(2,2,4), imshow(im_edges)
            title(titulo)
            
            % Parameters:
            grdthres = 1.5;
            fltr4LM_R = 20;
            
%             grdthres = percen_grdthres * double(max(im_windowed_gray(:)));
            minrad = round(min(size(im_windowed,1), size(im_windowed,2)) / 3);
            maxrad = round(min(size(im_windowed,1), size(im_windowed,2)) / 2 * 1.2);
%             fltr4LM_R = max(3, round(fltr4LM_R * max(w,h) / (4 * minrad)));

            % Compute the Hough Transform searching for circles:
            % It is important to note that we are feeding this function
            % with the greyscale image, not the edges one. This means the
            % edges we are finding may not be the ones actually used inside
            % the function.
            [accum, circen, cirrad] = CircularHough_Grd(im_windowed_gray, ...
                                        [minrad, maxrad], grdthres, fltr4LM_R);
            
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
            title(['Raw Image with Circles Detected ', '(center positions and radii marked)']);
        end
    end
    %Save the final windows and the output mask
%     figure(1)
%     subplot(3,1,3),
%     imshow( out_mask, [0,1]), title('template matching')
    %imwrite(out_mask,[outputDir fileId '.png']);
    %save([outputDir fileId '.mat'],'windowCandidates');
% end