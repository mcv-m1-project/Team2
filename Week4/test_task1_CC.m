    close all,
    addpath('..')
    addpath('..\evaluation')
    dirTrain = [pwd, '\..\..\train'];
    %inputMasksDir = [dirTrain, '\result_masks\SlidingWindow\'];   
    inputMasksDir = [dirTrain, '\result_masks\CC\']; 

    outputDir = [dirTrain, '\result_masks\week4_task1_CC\'];
    if(7~=exist([dirTrain, '\result_masks\week4_task1_CC\'],'dir'))
    mkdir([dirTrain, '\result_masks\week4_task1_CC\']);
    end
    
    files = ListFiles(dirTrain);
    nFiles = length(files);
    
    load('grayModels.mat');   
    load('maskModels.mat');  
    load('trainSetMaxCorrelationValues.mat');
    
    %Get the median and the minimum value of each traffic signal type correlation with
    %its template
    median_corr_up_triangle_gray = median(max_corr_up_triangle_gray)
    min_corr_up_triangle_gray = min(max_corr_up_triangle_gray)
    
    median_corr_down_triangle_gray = median(max_corr_down_triangle_gray)
    min_corr_down_triangle_gray = min(max_corr_down_triangle_gray)
    
    median_corr_square_gray = median(max_corr_square_gray)
    min_corr_square_gray = min(max_corr_square_gray)
    
    median_corr_circle_gray = median(max_corr_circle_gray)
    min_corr_circle_gray = min(max_corr_circle_gray)
    
    array_corr = zeros(4,1);
    figure,
    for i=1:nFiles
        fileId = files(i).name(1:9);
        windowsSelected = [];
        %Load image
        im = imread([dirTrain, '\', files(i).name]);
        subplot(3,1,1),imshow(im)
        mask = imread([inputMasksDir fileId '.png']);
        %out_mask = imread([inputMasksDir 'mask\' fileId '.png']);
        subplot(3,1,2), imshow( mask, [0,1]), title('CC windows mask')
                
        out_mask = im(:,:,1).*0;
        %Load window candidates for this image
        windowCandidates = load([inputMasksDir fileId '.mat']);
        window = windowCandidates.windowCandidates(1);
        %check if the window is empty
        if(window.w == 0)
            windowsSelected = [windowsSelected ; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        else
            size_win = size(windowCandidates.windowCandidates,2);
            for idx=1:size(windowCandidates.windowCandidates,2)
                window = windowCandidates.windowCandidates(idx);
                im_windowed = imcrop(im,[window.x+1,window.y+1,window.w-1,window.h-1]);
                %im_windowed = imcrop(im,[window.x,window.y,window.w-1,window.h-1]);
                im_windowed_gray = rgb2gray(im_windowed);
                
                %1 - Down Triangle
                template_down_triangle_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                corr_1 = normxcorr2(template_down_triangle_gray,im_windowed_gray);
                [ypeak, xpeak] = find(corr_1==max(corr_1(:)));
                array_corr(1) = corr_1(ypeak, xpeak);
                
                %2 - Up Triangle
                template_up_triangle_gray = imresize(upTriangleTemp_gray,size(im_windowed_gray));
                corr_2 = normxcorr2(template_up_triangle_gray,im_windowed_gray);
                [ypeak, xpeak] = find(corr_2==max(corr_2(:)));
                array_corr(2) = corr_2(ypeak, xpeak);
                
                %3 - Square
                template_square_gray = imresize(squareTemp_gray,size(im_windowed_gray));
                corr_3 = normxcorr2(template_square_gray,im_windowed_gray);
                [ypeak, xpeak] = find(corr_3==max(corr_3(:)));
                array_corr(3) = corr_3(ypeak, xpeak);
                
                %4 - Circle
                template_circle_gray = imresize(circleTemp_gray,size(im_windowed_gray));
                corr_4 = normxcorr2(template_circle_gray,im_windowed_gray);
                %corr_4(corr_4 <0) = 0.0001;
                [ypeak, xpeak] = find(corr_4==max(corr_4(:)));
                array_corr(4) = corr_4(ypeak, xpeak);
                signal_detected = false;
                no_signal_detected = false;
                signal_type = 0;
                while signal_detected == false && no_signal_detected == false
                    max_corr = find(array_corr==max(array_corr(:)));
                    if(size(max_corr,2) > 1 || size(max_corr,1) > 1)
                        %No signal found
                        max_corr = 0;
                        no_signal_detected = true;
                        break;
                    end
                    switch max_corr
                        case 1
                            if(array_corr(1) >= median_corr_down_triangle_gray)
                                %Down Ttriangle detected
                                signal_detected = true;
                                signal_type = 1;
                                [ypeak, xpeak] = find(corr_1==max(corr_1(:)));
                                mask_resized = imresize(downTriangleTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(1) = 0;
                            end
                        case 2
                            if(array_corr(2) >= median_corr_up_triangle_gray)
                                %Up Ttriangle detected
                                signal_detected = true;
                                signal_type = 2;
                                [ypeak, xpeak] = find(corr_2==max(corr_2(:)));
                                mask_resized = imresize(upTriangleTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(2) = 0;
                            end
                        case 3
                            if(array_corr(3) >= median_corr_square_gray)
                                %Square detected
                                signal_detected = true;
                                signal_type = 3;
                                [ypeak, xpeak] = find(corr_3==max(corr_3(:)));
                                mask_resized = imresize(squareTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(3) = 0;
                            end
                        case 4
                            if(array_corr(4) >= median_corr_circle_gray)
                                %Cricle detected
                                signal_detected = true;
                                signal_type = 4;
                                [ypeak, xpeak] = find(corr_4==max(corr_4(:)));
                                mask_resized = imresize(circleTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(4) = 0;
                            end
                        otherwise
                            no_signal_detected = true;
                    end
                end
                if(signal_detected == true)
                    out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w) = mask_resized | out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w);
                    windowsSelected = [windowsSelected ; struct('x',window.x+1,'y',window.y+1,'w',window.w,'h',window.h)];
%                     out_mask(window.y:window.y+window.h-1, window.x:window.x+window.w-1) = mask_resized | out_mask(window.y:window.y+window.h-1, window.x:window.x+window.w-1);
%                     windowsSelected = [windowsSelected ; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
                end
            end
        end
        %Save the final windows and the output mask
        subplot(3,1,3), imshow( out_mask, [0,1]), title('template matching')
        imwrite(out_mask,[outputDir fileId '.png']);
        save([outputDir fileId '.mat'],'windowsSelected');
    end
