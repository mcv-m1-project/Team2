function templateMatchingUsingCCWindows(dirTestImages, dirInputCCWindows, outputDir, up_triangle_th, down_triangle_th, circle_th, square_th)
%TEMPLATEMATCHINGUSINGCC

%   dirTestImages --> Path to the input images
%   dirInputCCWindows --> Path to the selected windows in CC
%   outputDir --> Path to the output masks and selected windows
%   up_triangle_th --> max correlation value for the up triangle signals
%   down_triangle_th --> max correlation value for the down triangle signals
%   circle_th --> max correlation value for the circle signals
%   square_th --> max correlation value for the square signals

    addpath('..')
    addpath('..\evaluation')

    if(7~=exist(outputDir,'dir'))
        mkdir(outputDir);
    end
    
    files = ListFiles(dirTestImages);
    nFiles = length(files);
    
    load('grayModels.mat');   
    load('maskModels.mat');  
    load('trainSetMaxCorrelationValues.mat');
    
    %Normalize the templates energy
    downTriangleTemp_gray = double(downTriangleTemp_gray)./sqrt(sum(downTriangleTemp_gray(:).^2)).*255;
    upTriangleTemp_gray = double(upTriangleTemp_gray)./sqrt(sum(upTriangleTemp_gray(:).^2)).*255;
    circleTemp_gray = double(circleTemp_gray)./sqrt(sum(circleTemp_gray(:).^2)).*255;
    squareTemp_gray = double(squareTemp_gray)./sqrt(sum(squareTemp_gray(:).^2)).*255;

    %Correlation max array declaration
    array_corr = zeros(4,1);
    
    for i=1:nFiles
        fileId = files(i).name(1:9);
        windowsSelected = [];
        %Load image
        im = imread([dirTestImages, '\', files(i).name]);
%         figure(1)
%         subplot(3,1,1),imshow(im)
%         mask = imread([dirInputMasks fileId '.png']);
%         subplot(3,1,2), imshow( mask, [0,1]), title('CC windows mask')
        out_mask = im(:,:,1).*0;
        %Load window candidates for this image
        windowCandidates = load([dirInputCCWindows fileId '.mat']);
        window = windowCandidates.windowCandidates(1);
        %check if the window is empty
        if(window.w == 0)
            windowsSelected = [windowsSelected ; struct('x',window.x,'y',window.y,'w',window.w,'h',window.h)];
        else
            size_win = size(windowCandidates.windowCandidates,2);
            for idx=1:size(windowCandidates.windowCandidates,2)
                window = windowCandidates.windowCandidates(idx);
                im_windowed = imcrop(im,[window.x+1,window.y+1,window.w-1,window.h-1]);
                im_windowed_gray = rgb2gray(im_windowed);
                
                %1 - Down Triangle
                template_down_triangle_gray = imresize(downTriangleTemp_gray,size(im_windowed_gray));
                corr_1 = normxcorr2(template_down_triangle_gray,im_windowed_gray);
                [ypeak, xpeak] = find(abs(corr_1)==max(abs(corr_1(:))));
                array_corr(1) = abs(corr_1(ypeak, xpeak));
%                 figure(2)
%                 subplot(3,1,1), imshow(im_windowed_gray)
%                 subplot(3,1,2), imshow(template_down_triangle_gray)
%                 subplot(3,1,3), imshow(abs(corr_1))
                
                %2 - Up Triangle
                template_up_triangle_gray = imresize(upTriangleTemp_gray,size(im_windowed_gray));
                corr_2 = normxcorr2(template_up_triangle_gray,im_windowed_gray);
                [ypeak, xpeak] = find(abs(corr_2)==max(abs(corr_2(:))));
                array_corr(2) = abs(corr_2(ypeak, xpeak));
%                 subplot(3,1,2), imshow(template_up_triangle_gray)
%                 subplot(3,1,3), imshow(abs(corr_2))
                
                %3 - Square
                template_square_gray = imresize(squareTemp_gray,size(im_windowed_gray));
                corr_3 = normxcorr2(template_square_gray,im_windowed_gray);
                [ypeak, xpeak] = find(abs(corr_3)==max(abs(corr_3(:))));
                array_corr(3) = abs(corr_3(ypeak, xpeak));
%                 subplot(3,1,2), imshow(template_square_gray)
%                 subplot(3,1,3), imshow(abs(corr_3))
                
                %4 - Circle
                template_circle_gray = imresize(circleTemp_gray,size(im_windowed_gray));
                corr_4 = normxcorr2(template_circle_gray,im_windowed_gray);
                [ypeak, xpeak] = find(abs(corr_4)==max(abs(corr_4(:))));
                array_corr(4) = abs(corr_4(ypeak, xpeak));
%                 subplot(3,1,2), imshow(template_circle_gray)
%                 subplot(3,1,3), imshow(abs(corr_4))
                
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
                            if(array_corr(1) >= down_triangle_th)
                                %Down Ttriangle detected
                                signal_detected = true;
                                signal_type = 1;
                                [ypeak, xpeak] = find(abs(corr_1)==max(abs(corr_1(:))));
                                mask_resized = imresize(downTriangleTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(1) = 0;
                            end
                        case 2
                            if(array_corr(2) >= up_triangle_th)
                                %Up Ttriangle detected
                                signal_detected = true;
                                signal_type = 2;
                                [ypeak, xpeak] = find(abs(corr_2)==max(abs(corr_2(:))));
                                mask_resized = imresize(upTriangleTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(2) = 0;
                            end
                        case 3
                            if(array_corr(3) >= square_th)
                                %Square detected
                                signal_detected = true;
                                signal_type = 3;
                                [ypeak, xpeak] = find(abs(corr_3)==max(abs(corr_3(:))));
                                mask_resized = imresize(squareTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(3) = 0;
                            end
                        case 4
                            if(array_corr(4) >= circle_th)
                                %Cricle detected
                                signal_detected = true;
                                signal_type = 4;
                                [ypeak, xpeak] = find(abs(corr_4)==max(abs(corr_4(:))));
                                mask_resized = imresize(circleTemp_mask,size(im_windowed_gray));
                            else
                                array_corr(4) = 0;
                            end
                        otherwise
                            no_signal_detected = true;
                    end
                end
                if(signal_detected == true)
%                     ypeak = ypeak - ((size(mask_resized,1) - 1)/2);
%                     xpeak = xpeak - ((size(mask_resized,2) - 1)/2);                                
                    out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w) = mask_resized | out_mask(window.y+1:window.y+window.h, window.x+1:window.x+window.w);
                    windowsSelected = [windowsSelected ; struct('x',window.x+1,'y',window.y+1,'w',window.w,'h',window.h)];
                end
            end
        end
        %Save the final windows and the output mask
%         figure(1)
%         subplot(3,1,3),
%         imshow( out_mask, [0,1]), title('template matching')
        imwrite(out_mask,[outputDir fileId '.png']);
        save([outputDir fileId '.mat'],'windowsSelected');
    end

end