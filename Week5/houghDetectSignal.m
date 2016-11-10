function houghDetectSignal(dirTestImages, inputWindowsDir, outputDir, delta_theta_90, delta_theta_30, delta_theta_0)
%HOUGHDETECTSIGNAL

%   dirTestImages --> Path to the input images
%   dirInputCCWindows --> Path to the selected windows in CC
%   outputDir --> Path to the output masks and selected windows
%   delta_theta_90 --> angle maximum deviation from 90 degrees (for horizontal lines)
%   delta_theta_30 --> angle maximum deviation from 30 degrees (for triangle lines)
%   delta_theta_0 --> angle maximum deviation from 0 degrees (for vertical lines)

   files = ListFiles(dirTestImages);
    nFiles = length(files);
    
    if(7~=exist(outputDir,'dir'))
        mkdir(outputDir);
    end
    
    % Parameters for Canny edge detector:
    threshold_canny = [0.05, 0.2];
    sigma = 1;
    
    load('signals_main_parameters.mat');
     minSize = min(min_size);
     maxSize = max(max_size);
     minFf = min(form_factor);
     maxFf = max(form_factor);
     min_width = round(sqrt(minSize*minFf));
     min_height = round(sqrt(minSize/maxFf));

    for i=1:nFiles
        fileId = files(i).name(1:9);
        windowCandidates = [];
        %Load image
        im = imread([dirTestImages, '\', files(i).name]);
        %Read input mask
        mask = imread([inputWindowsDir fileId '.png']);
        %Creat output mask
        out_mask = im(:,:,1).*0;
                
        %         figure(3)
        %         subplot(3,1,1),imshow(im)
        %         mask = imread([dirInputMasks fileId '.png']);
        %         subplot(3,1,2), imshow( mask, [0,1]), title('CC windows mask')

        %Load window candidates for this image
        windowCC = load([inputWindowsDir fileId '.mat']);
        window = windowCC.windowCandidates(1);
        %Check if the window candidate array is empty
        if(window.w == 0)
            windowCandidates = [windowCandidates ; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        else
            for idx=1:size(windowCC.windowCandidates,2)
                window = windowCC.windowCandidates(idx);
                %Crop de candidate window image (just for imshow)
                %im_windowed = imcrop(im,[window.x+1,window.y+1,window.w-1,window.h-1]);
                %im_windowed_gray = rgb2gray(im_windowed);
                
                %Crop de candidate window mask
                mask_windowed = imcrop(mask,[window.x+1,window.y+1,window.w-1,window.h-1]);
                % Compute mask edges with Canny:
                mask_edges = edge(mask_windowed, 'canny', threshold_canny, sigma);
                
%                 figure(1)
%                 subplot(2,2,1), imshow(im_windowed_gray)
%                 subplot(2,2,2), imshow(mask_windowed, [0,1])
%                 subplot(2,2,3), imshow(mask_edges)
                
                %Compute the Hough Transform of the edges binary image
                [H,theta,rho] = hough(mask_edges);
                
%                 figure(2)
%                 imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho,...
%                     'InitialMagnification','fit'), hold on
%                 title('Hough transform of gantrycrane.png');
%                 xlabel('\theta'), ylabel('\rho');
%                 axis on, axis normal, hold on;
%                 colormap(gca,hot);

                %Find peaks in Hough Transform
                P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
                
                %Superimpose a plot on the image of the transform that identifies the peaks
%                 x = theta(P(:,2));
%                 y = rho(P(:,1));
%                 figure(2)
%                 plot(x,y,'s','color','black');
%                 hold off

                %Find lines in the image using the houghlines function.
                lines = houghlines(mask_edges,theta,rho,P,'FillGap',5,'MinLength',7);
                
                %Create a plot that displays the original image with the lines superimposed on it.
%                 figure(1), subplot(2,2,4), imshow(im_windowed_gray), hold on
%                 max_len = 0;
%                 for k = 1:length(lines)
%                     xy = [lines(k).point1; lines(k).point2];
%                     plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%                     
%                     % Plot beginnings and ends of lines
%                     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%                     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%                     
%                     % Determine the endpoints of the longest line segment
%                     len = norm(lines(k).point1 - lines(k).point2);
%                     if ( len > max_len)
%                         max_len = len;
%                         xy_long = xy;
%                     end
%                 end
%                 % highlight the longest line segment
%                 plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
%                 hold off
                
                %Create three arrays to store the horizontal, vertical and
                %triangle (30 degrees) lines
                hor_line = [];
                vert_line = [];
                triang_line = [];               
                for k = 1:length(lines)
                    xy = [lines(k).point1; lines(k).point2];
                    if((abs(lines(k).theta) >= 90 - delta_theta_90) && (abs(lines(k).theta) <= 90 + delta_theta_90))
                        %Horizontal line detected
                        hor_line = [hor_line; [lines(k).point1 lines(k).point2]];
                    elseif((abs(lines(k).theta) >= 0 - delta_theta_0) && (abs(lines(k).theta) <= 0 + delta_theta_0))
                        %Vertical line detected
                        vert_line = [vert_line; [lines(k).point1, lines(k).point2]];
                    elseif((abs(lines(k).theta) >= 30 - delta_theta_30) && (abs(lines(k).theta) <= 30 + delta_theta_30))
                        %30 degrees detected
                        triang_line = [triang_line; [lines(k).point1, lines(k).point2, lines(k).theta]];
                    end
                end
                hor_lines_counter = size(hor_line,1);
                vert_lines_counter = size(vert_line,1);
                triang_lines_counter = size(triang_line,1);
                hor_lines_signal = 0;
                vert_lines_signal = 0;
                triang_lines_signal = 0;
                
                %Identify if there are two different horizontal lines in the image
                if (hor_lines_counter > 1)
                    height_diff = 0;
                    for idx = 1:size(hor_line,1)
                        diff_h = min(abs(hor_line(1,2) - hor_line(idx,2)),abs(hor_line(1,2) - hor_line(idx,2)));
                        if(diff_h > height_diff)
                            height_diff = diff_h;
                        end
                    end
                    if(height_diff < min_height)
                        hor_lines_signal = 1;
                    else
                        hor_lines_signal = 2;
                    end
                end
                
                %Identify if there are two different vertical lines in the image
                if (vert_lines_counter > 1)
                    width_diff = 0;
                    for idx = 1:size(vert_line,1)
                        diff_w = min(abs(vert_line(1,1) - vert_line(idx,1)),abs(vert_line(1,1) - vert_line(idx,1)));
                        if(diff_w > width_diff)
                            width_diff = diff_w;
                        end
                    end
                    if(width_diff < min_width)
                        vert_lines_signal = 1;
                    else
                        vert_lines_signal = 2;
                    end
                end
                
                %Identify if there are two different 30 degrees triangle
                %lines
                if (triang_lines_counter > 1)
                    positive_30_degrees = 0;
                    negative_30_degrees = 0;
                    for idx = 1:size(triang_line,1)
                        if(triang_line(idx,5) > 0)
                            positive_30_degrees = positive_30_degrees + 1;
                        else
                            negative_30_degrees = negative_30_degrees + 1;
                        end
                    end
                    if((positive_30_degrees > 0) && (negative_30_degrees > 0) )
                        triang_lines_signal = 2;
                    else
                        triang_lines_signal = 1;
                    end
                end
                
                %Check if a square signal was detected
                if((hor_lines_signal > 0) && (vert_lines_signal > 0))
                    square_detected = true;
                elseif((hor_lines_signal > 1) || (vert_lines_signal > 1))
                    square_detected = true;
                else
                    square_detected = false;
                end
                
                %Check if a triangle signal detected
                if(triang_lines_signal > 1)
                    triangle_detected = true;
                elseif((triang_lines_signal == 1) && (hor_lines_signal > 0))
                    triangle_detected = true;
                else
                    triangle_detected = false;
                end
                
                %If a triangle or a square image is detected write to the
                %output mask and save the window candidate
                if((triangle_detected == true) || (square_detected == true))
                    out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w) = mask_windowed | out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w);
                    windowCandidates = [windowCandidates ; struct('x',window.x+1,'y',window.y+1,'w',window.w,'h',window.h)];
                end
            end
        end
        %Save the final windows and the output mask
        %         figure(3)
        %         subplot(3,1,3),
        %         imshow( out_mask, [0,1]), title('template matching')
        imwrite(out_mask,[outputDir fileId '.png']);
        save([outputDir fileId '.mat'],'windowCandidates');
    end

end