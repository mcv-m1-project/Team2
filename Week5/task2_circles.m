function task2_circles(dirTestImages, inputWindowsDir, outputDir, grdthres, fltr4LM_R, resize)


files = ListFiles(dirTestImages);
nFiles = length(files);

if(7~=exist(outputDir,'dir'))
    mkdir(outputDir);
end



fprintf('\nHough circle detection...\n')
progress = 10;
fprintf('Completed 0%%\n')
for i = 1:nFiles
    if(i > progress / 100 * nFiles)
        fprintf('Completed %i%%\n', progress)
        progress = progress + 10;
    end
    
    fileId = files(i).name(1:9);
    windowCandidates = [];
    
    % Load image
    im = imread([dirTestImages, '\', files(i).name]);
    
    % Load window candidates for this image
    windowCC = load([inputWindowsDir fileId '.mat']);
    window = windowCC.windowCandidates(1);
    
    % Check if the window is empty
    if(window.x == 0 || ...
       window.y == 0 || ...
       window.w == 0 || ...
       window.h == 0)
        windowCandidates = [windowCandidates; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        
    % A window cannot be smaller than 32x32 to perform Hough circle
    % detection.
    elseif(window.h < 32 || window.w < 32)
        windowCandidates = [windowCandidates; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        
    else
        size_win = size(windowCC.windowCandidates,2);
        for idx = 1:size_win
            window = windowCC.windowCandidates(idx);
            x = window.x;
            y = window.y;
            w = window.w;
            h = window.h;
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
            [~, ~, cirrad] = CircularHough_Grd(im_windowed_gray, ...
                                [minrad, maxrad], grdthres, fltr4LM_R);

            % Decide if accepting the window or not:
            if(~isempty(cirrad))
                windowCandidates = [windowCandidates; struct('x', x, 'y', y, 'w', w, 'h', h)];
            end
        end
    end
    %Save the final windows and the output mask
%     figure(1)
%     subplot(3,1,3),
%     imshow( out_mask, [0,1]), title('template matching')
%     imwrite(out_mask,[outputDir fileId '.png']);
    save([outputDir, fileId, '.mat'], 'windowCandidates');
end
fprintf('Completed 100%%\n')

