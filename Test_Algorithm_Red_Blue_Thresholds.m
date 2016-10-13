clear all
close all
% We add the path where some scripts are.
addpath('evaluation\')
addpath('colorspace\')
addpath('..\train\')

% Base directory:
dirbase = pwd;
% Path to the training dataset images
dirTrainDataSet = [dirbase, '\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirTrainDataSet, '\gt'];
% Path to Masks:
dirmask = [dirTrainDataSet, '\mask'];

%Load variables from week1_task1 to save computation time
load('signals_workspace.mat');

%Separate the train from the validation images
[trainSet, validationSet] = train_validation_split(dirTrainDataSet, nrepetitions);

%Call the function to build and save the 2D histograms for each signal type
%using Lab color space
%week1_task3_signal_types_2D_ab_histograms(dirTrainDataSet, trainSet, signals)
  
%Find masks and suitable thresholds........

counter_type_a = 0;
counter_type_b = 0;
counter_type_c = 0;
counter_type_d = 0;
counter_type_e = 0;
counter_type_f = 0;
for idx = 1:size(trainSet,2) 
    im_index = find( strcmp({signals(:).filename},trainSet{idx}));
    if (isempty(im_index) == 0)
        %Each image can contain more than one signal
        for jdx=1:size(im_index)
            im_test = signals(im_index(jdx)).image;
            switch signals(im_index(jdx)).type
                case 'A'
                    counter_type_a = counter_type_a + 1;
                    signalsA(counter_type_a) = signals(im_index(jdx));
                case 'B'
                    counter_type_b = counter_type_b + 1;
                    signalsB(counter_type_b) = signals(im_index(jdx));
                case 'C'
                    counter_type_c = counter_type_c + 1;
                    signalsC(counter_type_c) = signals(im_index(jdx));
                case 'D'
                    counter_type_d = counter_type_d + 1;
                    signalsD(counter_type_d) = signals(im_index(jdx));
                case 'E'
                    counter_type_e = counter_type_e + 1;
                    signalsE(counter_type_e) = signals(im_index(jdx));
                case 'F'
                    counter_type_f = counter_type_f + 1;
                    signalsF(counter_type_f) = signals(im_index(jdx));
            end
        end
    end
end

% Blue
[XinF, XoutF] = create_Xin_Xout(signalsF, image_list, dirTrainDataSet, mask_list, dirmask);

% Convert to Lab, from RGB in [0,1]:
npixels = size(XinF,1);
XinF_lab = rgb2lab(XinF/ 255);
XoutF_lab = rgb2lab(XoutF/ 255);

ntrials = 20;
step2 = (max(XinF_lab(:,2)) - min(XinF_lab(:,2))) / (ntrials-1);
step3 = (max(XinF_lab(:,3)) - min(XinF_lab(:,3))) / (ntrials-1);
th2_vec = min(XinF_lab(:,2)) : step2 : max(XinF_lab(:,2));
th3_vec = min(XinF_lab(:,3)) : step3 : max(XinF_lab(:,3));
min_percenin = 30;
[lowth2_blue, highth2_blue, lowth3_blue, highth3_blue] = find_segmentation_4ths(th2_vec, th3_vec, ...
                                           min_percenin, npixels, XinF_lab, XoutF_lab);
                                 
thresholds_blue = [lowth2_blue, highth2_blue, lowth3_blue, highth3_blue];
                              
% Red
[XinC, XoutC] = create_Xin_Xout(signalsC, image_list, dirTrainDataSet, mask_list, dirmask);

% Convert to Lab, from RGB in [0,1]:
npixels = size(XinC,1);
XinC_lab = rgb2lab(XinC/ 255);
XoutC_lab = rgb2lab(XoutC/ 255);

ntrials = 20;
step2 = (max(XinC_lab(:,2)) - min(XinC_lab(:,2))) / (ntrials-1);
step3 = (max(XinC_lab(:,3)) - min(XinC_lab(:,3))) / (ntrials-1);
th2_vec = min(XinC_lab(:,2)) : step2 : max(XinC_lab(:,2));
th3_vec = min(XinC_lab(:,3)) : step3 : max(XinC_lab(:,3));
min_percenin = 30;
[lowth2_red, highth2_red, lowth3_red, highth3_red] = find_segmentation_4ths(th2_vec, th3_vec, ...
                                     min_percenin, npixels, XinC_lab, XoutC_lab);
                                 
thresholds_red = [lowth2_red, highth2_red, lowth3_red, highth3_red];

save('red_blue_thresholds', 'thresholds_red', 'thresholds_blue');

% Check on the validation split images:
lowth2_blue = thresholds_blue(1);
highth2_blue = thresholds_blue(2);
lowth3_blue = thresholds_blue(3);
highth3_blue = thresholds_blue(4);
lowth2_red = thresholds_red(1);
highth2_red = thresholds_red(2);
lowth3_red = thresholds_red(3);
highth3_red = thresholds_red(4);

%Every time an image is display it will wait for mouse click or enter to
%display the next one.
figure, 
for idx = 1:size(validationSet,2)
    im_test = imread([dirTrainDataSet '\' validationSet{idx} '.jpg']);
    image_lab = rgb2lab(im_test);
    mask = image_lab(:,:,2) > lowth2_blue & image_lab(:,:,2) < highth2_blue | ...
       image_lab(:,:,2) > lowth2_red & image_lab(:,:,2) < highth2_red | ...
       image_lab(:,:,3) > lowth3_blue & image_lab(:,:,3) < highth3_blue | ...
       image_lab(:,:,3) > lowth3_red & image_lab(:,:,3) < highth3_red;
   
    subplot(1,2,1), imshow(image)  
    subplot(1,2,2), imshow(mask, [0 1])

    w = waitforbuttonpress;
end







