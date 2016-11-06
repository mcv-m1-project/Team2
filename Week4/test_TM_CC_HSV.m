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
    
%     [max_corr_up_triangle_hs, max_corr_down_triangle_hs, max_corr_square_hs, max_corr_circle_C_hs, max_corr_circle_D_hs, max_corr_circle_E_hs] = getMaximumCorrelationTrafficSignalTemplates_HSV(dirTrain)
%     save('trainSetMaxCorrelationValues_HSV', 'max_corr_up_triangle_hs', 'max_corr_down_triangle_hs', 'max_corr_square_hs', 'max_corr_circle_C_hs', 'max_corr_circle_D_hs', 'max_corr_circle_E_hs');
      
    load('maskModels_6types.mat');  
    load('trainSetMaxCorrelationValues_HSV.mat');
    min_corr_up_triangle_h = min(max_corr_up_triangle_hs(1,:));
    min_corr_up_triangle_s = min(max_corr_up_triangle_hs(2,:));
    min_corr_down_triangle_h = min(max_corr_down_triangle_hs(1,:));
    min_corr_down_triangle_s = min(max_corr_down_triangle_hs(2,:));
    min_corr_square_h = min(max_corr_square_hs(1,:));
    min_corr_square_s = min(max_corr_square_hs(2,:));
    min_corr_circle_C_h = min(max_corr_circle_C_hs(1,:));
    min_corr_circle_C_s = min(max_corr_circle_C_hs(2,:));
    min_corr_circle_D_h = min(max_corr_circle_D_hs(1,:));
    min_corr_circle_D_s = min(max_corr_circle_D_hs(2,:));
    min_corr_circle_E_h = min(max_corr_circle_E_hs(1,:));
    min_corr_circle_E_s = min(max_corr_circle_E_hs(2,:));
    
    median_corr_up_triangle_h =  median(max_corr_up_triangle_hs(1,:));
    median_corr_up_triangle_s =  median(max_corr_up_triangle_hs(2,:));
    median_corr_down_triangle_h =  median(max_corr_down_triangle_hs(1,:));
    median_corr_down_triangle_s =  median(max_corr_down_triangle_hs(2,:));
    median_corr_square_h =  median(max_corr_square_hs(1,:));
    median_corr_square_s =  median(max_corr_square_hs(2,:));
    median_corr_circle_C_h =  median(max_corr_circle_C_hs(1,:));
    median_corr_circle_C_s =  median(max_corr_circle_C_hs(2,:));
    median_corr_circle_D_h =  median(max_corr_circle_D_hs(1,:));
    median_corr_circle_D_s =  median(max_corr_circle_D_hs(2,:));
    median_corr_circle_E_h =  median(max_corr_circle_E_hs(1,:));
    median_corr_circle_E_s =  median(max_corr_circle_E_hs(2,:));

    load('hsvModels_6types.mat');
    
    downTriangleTemp_h = downTriangleTemp_hsv(:,:,1);
    downTriangleTemp_h = downTriangleTemp_h./sqrt(sum(downTriangleTemp_h(:).^2));    
    downTriangleTemp_s = downTriangleTemp_hsv(:,:,2);
    downTriangleTemp_s = downTriangleTemp_s./sqrt(sum(downTriangleTemp_s(:).^2)); 
    upTriangleTemp_h = upTriangleTemp_hsv(:,:,1);
    upTriangleTemp_h = upTriangleTemp_h./sqrt(sum(upTriangleTemp_h(:).^2));
    upTriangleTemp_s = upTriangleTemp_hsv(:,:,2);
    upTriangleTemp_s = upTriangleTemp_s./sqrt(sum(upTriangleTemp_s(:).^2));      
    squareTemp_h = squareTemp_hsv(:,:,1);
    squareTemp_h = squareTemp_h./sqrt(sum(squareTemp_h(:).^2));
    squareTemp_s = squareTemp_hsv(:,:,2);
    squareTemp_s = squareTemp_s./sqrt(sum(squareTemp_s(:).^2));
    circleTemp_C_h = circleTemp_C_hsv(:,:,1);
    circleTemp_C_h = circleTemp_C_h./sqrt(sum(circleTemp_C_h(:).^2));
    circleTemp_C_s = circleTemp_C_hsv(:,:,2); 
    circleTemp_C_s = circleTemp_C_s./sqrt(sum(circleTemp_C_s(:).^2));
    circleTemp_D_h = circleTemp_D_hsv(:,:,1);
    circleTemp_D_h = circleTemp_D_h./sqrt(sum(circleTemp_D_h(:).^2));
    circleTemp_D_s = circleTemp_D_hsv(:,:,2);
    circleTemp_D_s = circleTemp_D_s./sqrt(sum(circleTemp_D_s(:).^2));
    circleTemp_E_h = circleTemp_E_hsv(:,:,1);
    circleTemp_E_h = circleTemp_E_h./sqrt(sum(circleTemp_E_h(:).^2));
    circleTemp_E_s = circleTemp_E_hsv(:,:,2);
    circleTemp_E_s = circleTemp_E_s./sqrt(sum(circleTemp_E_s(:).^2));

    
    array_err_corr = zeros(6,1);
    for i=1:nFiles
        i
        fileId = files(i).name(1:9);
        windowsSelected = [];
        %Load image
        im = imread([dirTrain, '\', files(i).name]);
%         figure(1)
%         subplot(3,1,1),imshow(im)
%         mask = imread([inputMasksDir fileId '.png']);
%         %out_mask = imread([inputMasksDir 'mask\' fileId '.png']);
%         subplot(3,1,2), imshow( mask, [0,1]), title('CC windows mask')
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
                im_windowed_hsv = rgb2hsv(im_windowed);
                im_windowed_h = im_windowed_hsv(:,:,1);
                im_windowed_s = im_windowed_hsv(:,:,2);
                im_windowed_h = im_windowed_h./sqrt(sum(im_windowed_h(:).^2));
                im_windowed_s = im_windowed_s./sqrt(sum(im_windowed_s(:).^2));
                
                %1 - Down Triangle
                template_down_triangle_h = imresize(downTriangleTemp_h,size(im_windowed_hsv(:,:,1)));
                corr_1_h = normxcorr2(template_down_triangle_h,im_windowed_h);
                [ypeak_h_1, xpeak_h_1] = find(abs(corr_1_h)==max(abs(corr_1_h(:))));
                
                template_down_triangle_s = imresize(downTriangleTemp_s,size(im_windowed_hsv(:,:,2)));
                corr_1_s = normxcorr2(template_down_triangle_s,im_windowed_s);
                [ypeak_s_1, xpeak_s_1] = find(abs(corr_1_s)==max(abs(corr_1_s(:))));
                
                array_err_corr(1) = (corr_1_h(ypeak_h_1, xpeak_h_1)-median_corr_down_triangle_h).^2 + (corr_1_s(ypeak_s_1, xpeak_s_1)-median_corr_down_triangle_s).^2;
                
                %2 - Up Triangle
                template_up_triangle_h = imresize(upTriangleTemp_h,size(im_windowed_hsv(:,:,1)));
                corr_2_h = normxcorr2(template_up_triangle_h,im_windowed_h);
                [ypeak_h_2, xpeak_h_2] = find(abs(corr_2_h)==max(abs(corr_2_h(:))));
                
                template_up_triangle_s = imresize(upTriangleTemp_s,size(im_windowed_hsv(:,:,2)));
                corr_2_s = normxcorr2(template_up_triangle_s,im_windowed_s);
                [ypeak_s_2, xpeak_s_2] = find(abs(corr_2_s)==max(abs(corr_2_s(:))));
                
                array_err_corr(2) = (corr_2_h(ypeak_h_2, xpeak_h_2)-median_corr_up_triangle_h).^2 + (corr_2_s(ypeak_s_2, xpeak_s_2)-median_corr_up_triangle_s).^2;
                
                %3 - Square
                template_square_h = imresize(squareTemp_h,size(im_windowed_hsv(:,:,1)));
                corr_3_h = normxcorr2(template_square_h,im_windowed_h);
                [ypeak_h_3, xpeak_h_3] = find(abs(corr_3_h)==max(abs(corr_3_h(:))));
                
                template_square_s = imresize(squareTemp_s,size(im_windowed_hsv(:,:,2)));
                corr_3_s = normxcorr2(template_square_s,im_windowed_s);
                [ypeak_s_3, xpeak_s_3] = find(abs(corr_3_s)==max(abs(corr_3_s(:))));
                
                array_err_corr(3) = (corr_3_h(ypeak_h_3, xpeak_h_3)-median_corr_square_h).^2 + (corr_3_s(ypeak_s_3, xpeak_s_3)-median_corr_square_s).^2;
                
                %4 - Circle
                template_circle_C_h = imresize(circleTemp_C_h,size(im_windowed_hsv(:,:,1)));
                corr_4_h = normxcorr2(template_circle_C_h,im_windowed_h);
                [ypeak_h_4, xpeak_h_4] = find(abs(corr_4_h)==max(abs(corr_4_h(:))));
                
                template_circle_C_s = imresize(circleTemp_C_s,size(im_windowed_hsv(:,:,2)));
                corr_4_s = normxcorr2(template_circle_C_s,im_windowed_s);
                [ypeak_s_4, xpeak_s_4] = find(abs(corr_4_s)==max(abs(corr_4_s(:))));
                
                array_err_corr(4) = (corr_4_h(ypeak_h_4, xpeak_h_4)-median_corr_circle_C_h).^2 + (corr_4_s(ypeak_s_4, xpeak_s_4)-median_corr_circle_C_s).^2;
                
                template_circle_D_h = imresize(circleTemp_D_h,size(im_windowed_hsv(:,:,1)));
                corr_5_h = normxcorr2(template_circle_D_h,im_windowed_h);
                [ypeak_h_5, xpeak_h_5] = find(abs(corr_5_h)==max(abs(corr_5_h(:))));
                
                template_circle_D_s = imresize(circleTemp_D_s,size(im_windowed_hsv(:,:,2)));
                corr_5_s = normxcorr2(template_circle_D_s,im_windowed_s);
                [ypeak_s_5, xpeak_s_5] = find(abs(corr_5_s)==max(abs(corr_5_s(:))));
                
                array_err_corr(5) = (corr_5_h(ypeak_h_5, xpeak_h_5)-median_corr_circle_D_h).^2 + (corr_5_s(ypeak_s_5, xpeak_s_5)-median_corr_circle_D_s).^2;
                
                template_circle_E_h = imresize(circleTemp_E_h,size(im_windowed_hsv(:,:,1)));
                corr_6_h = normxcorr2(template_circle_E_h,im_windowed_h);
                [ypeak_h_6, xpeak_h_6] = find(abs(corr_6_h)==max(abs(corr_6_h(:))));
                
                template_circle_E_s = imresize(circleTemp_E_s,size(im_windowed_hsv(:,:,2)));
                corr_6_s = normxcorr2(template_circle_E_s,im_windowed_s);
                [ypeak_s_6, xpeak_s_6] = find(abs(corr_6_s)==max(abs(corr_6_s(:))));
                
                array_err_corr(6) = (corr_6_h(ypeak_h_6, xpeak_h_6)-median_corr_circle_E_h).^2 + (corr_6_s(ypeak_s_6, xpeak_s_6)-median_corr_circle_E_s).^2;
                
                signal_detected = false;
                no_signal_detected = false;
                signal_type = 0;
                while signal_detected == false && no_signal_detected == false
                    min_err_corr = find(array_err_corr==min(array_err_corr(:)));
                    if(size(min_err_corr,2) > 1 || size(min_err_corr,1) > 1)
                        %No signal found
                        min_err_corr = 0;
                        no_signal_detected = true;
                        break;
                    end
                    
                    switch min_err_corr
                        case 1
                            if((corr_1_h(ypeak_h_1, xpeak_h_1) >= min_corr_down_triangle_h) && (corr_1_s(ypeak_s_1, xpeak_s_1) >= min_corr_down_triangle_s))
                                %Down Ttriangle detected
                                signal_detected = true;
                                signal_type = 1;
                                mask_resized = imresize(downTriangleTemp_mask,size(im_windowed_hsv(:,:,1)));
                            else
                                array_err_corr(1) = inf;
                            end
                        case 2
                            if((corr_2_h(ypeak_h_2, xpeak_h_2) >= min_corr_up_triangle_h) && (corr_2_s(ypeak_s_2, xpeak_s_2) >= min_corr_up_triangle_s))
                                %Up Ttriangle detected
                                signal_detected = true;
                                signal_type = 2;
                                mask_resized = imresize(upTriangleTemp_mask,size(im_windowed_hsv(:,:,1)));
                            else
                                array_err_corr(2) = inf;
                            end
                        case 3
                            if((corr_3_h(ypeak_h_3, xpeak_h_3) >= min_corr_square_h) && (corr_3_s(ypeak_s_3, xpeak_s_3) >= min_corr_square_s))
                                %Square detected
                                signal_detected = true;
                                signal_type = 3;
                                mask_resized = imresize(squareTemp_mask,size(im_windowed_hsv(:,:,1)));
                            else
                                array_err_corr(3) = inf;
                            end
                        case 4
                            if((corr_4_h(ypeak_h_4, xpeak_h_4) >= median_corr_circle_C_h) && (corr_4_s(ypeak_s_4, xpeak_s_4) >= median_corr_circle_C_s))
                                %Cricle C detected
                                signal_detected = true;
                                signal_type = 4;
                                mask_resized = imresize(circleTemp_C_mask,size(im_windowed_hsv(:,:,1)));
                            else
                                array_err_corr(4) = inf;
                            end
                        case 5
                            if((corr_5_h(ypeak_h_5, xpeak_h_5) >= median_corr_circle_D_h) && (corr_5_s(ypeak_s_5, xpeak_s_5) >= median_corr_circle_D_s))
                                %Cricle D detected
                                signal_detected = true;
                                signal_type = 5;
                                mask_resized = imresize(circleTemp_D_mask,size(im_windowed_hsv(:,:,1)));
                            else
                                array_err_corr(5) = inf;
                            end
                        case 6
                            if((corr_6_h(ypeak_h_6, xpeak_h_6) >= median_corr_circle_E_h) && (corr_6_s(ypeak_s_6, xpeak_s_6) >= median_corr_circle_E_s))
                                %Cricle E detected
                                signal_detected = true;
                                signal_type = 6;
                                mask_resized = imresize(circleTemp_E_mask,size(im_windowed_hsv(:,:,1)));
                            else
                                array_err_corr(6) = inf;
                            end
                        otherwise
                            no_signal_detected = true;
                    end
                end
                if(signal_detected == true)         
                    out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w) = mask_resized | out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w);
                    windowsSelected = [windowsSelected ; struct('x',window.x+1,'y',window.y+1,'w',window.w,'h',window.h)];
                end
            end
        end
%         subplot(3,1,2), imshow( im_windowed_gray ), title('CC windows mask')
%         hold on
        %Save the final windows and the output mask
%         figure(1)
%         subplot(3,1,3),
%         imshow( out_mask, [0,1]), title('template matching')
        %imshow( mask_resized, [0,1]), title('template matching')
%         hold on
%         plot(xpeak, ypeak, 'ro')
%         hold off
        imwrite(out_mask,[outputDir fileId '.png']);
        save([outputDir fileId '.mat'],'windowsSelected');
    end
