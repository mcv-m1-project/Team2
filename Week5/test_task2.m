    close all,
    addpath('..\')
    addpath('..\evaluation')
    
    %Paths
    dirTestImages = [pwd, '\..\..\train']; 
    inputWindowsDir = [dirTestImages, '\result_masks\CC\']; 
    outputDir = [dirTestImages, '\result_masks\week5_task2_hough_transform\'];
    
    files = ListFiles(dirTestImages);
    nFiles = length(files);
    
        if(7~=exist(outputDir,'dir'))
        mkdir(outputDir);
        end
    
    % Parameters for Canny edge detector:
    threshold_canny = [0.05, 0.2];
    sigma = 1;
    
    load('signals_main_parameters.mat');
%     minSize = min(min_size);
%     maxSize = max(max_size);
%     minFf = min(formFactor);
%     maxFf = max(formFactor);
%     width = round(sqrt(window_size*form_factor));
%     height = round(sqrt(window_size/form_factor));
%     fr = (minSize*ff)/(width*height);

    files = ListFiles(dirTestImages);
    nFiles = length(files);
    
        for i=1:nFiles
        fileId = files(i).name(1:9);
        windowCandidates = [];
        %Load image
        im = imread([dirTestImages, '\', files(i).name]);
        mask = imread([inputWindowsDir fileId '.png']);
%         figure(1)
%         subplot(3,1,1),imshow(im)
%         mask = imread([dirInputMasks fileId '.png']);
%         subplot(3,1,2), imshow( mask, [0,1]), title('CC windows mask')
        out_mask = im(:,:,1).*0;
        %Load window candidates for this image
        windowCC = load([inputWindowsDir fileId '.mat']);
        window = windowCC.windowCandidates(1);
        %check if the window is empty
        if(window.w == 0)
            windowCandidates = [windowCandidates ; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        else
            size_win = size(windowCC.windowCandidates,2);
            for idx=1:size(windowCC.windowCandidates,2)
                window = windowCC.windowCandidates(idx);
                im_windowed = imcrop(im,[window.x+1,window.y+1,window.w-1,window.h-1]);
                im_windowed_gray = rgb2gray(im_windowed);
                mask_windowed = imcrop(mask,[window.x+1,window.y+1,window.w-1,window.h-1]);
                % Computing edges:
                %mask_edges = edge(mask_windowed, 'canny', threshold_canny, sigma);
                mask_edges = edge(mask_windowed, 'canny');
                
                figure(1)
                subplot(2,2,1), imshow(im_windowed_gray)
                subplot(2,2,2), imshow(mask_windowed, [0,1])
                subplot(2,2,3), imshow(mask_edges)
                
                %Compute the Hough Transform of the edges binary image
                %[H,T,R] = hough(BW,'RhoResolution',0.5,'ThetaResolution',0.5);
                %or
                [H,theta,rho] = hough(mask_edges);
                figure(2)
                imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho,...
                    'InitialMagnification','fit'), hold on
                title('Hough transform of gantrycrane.png');
                xlabel('\theta'), ylabel('\rho');
                axis on, axis normal, hold on;
                colormap(gca,hot);
                %Find peaks in Hough Transform
                P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
                %Superimpose a plot on the image of the transform that identifies the peaks
                x = theta(P(:,2));
                y = rho(P(:,1));
                figure(2)
                plot(x,y,'s','color','black');
                hold off
                %Find lines in the image using the houghlines function.
                lines = houghlines(mask_edges,theta,rho,P,'FillGap',5,'MinLength',7);
                %Create a plot that displays the original image with the lines superimposed on it.
                figure(1), subplot(2,2,4), imshow(im_windowed_gray), hold on
                max_len = 0;
                for k = 1:length(lines)
                    xy = [lines(k).point1; lines(k).point2];
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
                    
                    % Plot beginnings and ends of lines
                    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
                    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
                    
                    % Determine the endpoints of the longest line segment
                    len = norm(lines(k).point1 - lines(k).point2);
                    if ( len > max_len)
                        max_len = len;
                        xy_long = xy;
                    end
                end
                % highlight the longest line segment
                plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
                hold off 
                signal_detected = false;
                if(signal_detected == true)                              
                    out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w) = mask_resized | out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w);
                    windowCandidates = [windowCandidates ; struct('x',window.x+1,'y',window.y+1,'w',window.w,'h',window.h)];
                end
            end
        end
        %Save the final windows and the output mask
%         figure(1)
%         subplot(3,1,3),
%         imshow( out_mask, [0,1]), title('template matching')
        %imwrite(out_mask,[outputDir fileId '.png']);
        %save([outputDir fileId '.mat'],'windowCandidates');
    end
