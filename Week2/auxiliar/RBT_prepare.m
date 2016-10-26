function RBT_prepare(trainSet, signals, image_list, dirTrainDataSet, mask_list, dirmask, ngrid)

% Create structure vectors with the signals of each type in the train set:
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


%%%%%%%%%%%%%
% Blue
fprintf('\nComputing thresholds for blue colors (type F signals).\n')
[XinF, XoutF] = create_Xin_Xout(signalsF, image_list, dirTrainDataSet, mask_list, dirmask);

% Convert to Lab, from RGB in [0,1]:
npixels = size(XinF,1);
XinF_lab = rgb2lab(XinF/ 255);
XoutF_lab = rgb2lab(XoutF/ 255);

% Create the grid of thresholds:
step2 = (max(XinF_lab(:,2)) - min(XinF_lab(:,2))) / (ngrid-1);
step3 = (max(XinF_lab(:,3)) - min(XinF_lab(:,3))) / (ngrid-1);
ths_grid_a_blue = min(XinF_lab(:,2)) : step2 : max(XinF_lab(:,2));
ths_grid_b_blue = min(XinF_lab(:,3)) : step3 : max(XinF_lab(:,3));

% Compute the ratio of pixels found in the signal and outside of them for
% each combination of thresholds, and the percentage of pixels found
% inside:
[ratios_blue, percenin_array_blue] = RBT_compute_matrices_4ths(ths_grid_a_blue, ths_grid_b_blue, ...
                                           npixels, XinF_lab, XoutF_lab);

% Save the matrices with the results for the whole grid of thresholds:
save('RBT_matrices_blue', 'ratios_blue', 'percenin_array_blue', 'ths_grid_a_blue', 'ths_grid_b_blue')


%%%%%%%%%%%%%
% Red
fprintf('\nComputing thresholds for red colors (type C signals).\n')
[XinC, XoutC] = create_Xin_Xout(signalsC, image_list, dirTrainDataSet, mask_list, dirmask);

% Convert to Lab, from RGB in [0,1]:
npixels = size(XinC,1);
XinC_lab = rgb2lab(XinC/ 255);
XoutC_lab = rgb2lab(XoutC/ 255);

% Create the grid of thresholds:
step2 = (max(XinC_lab(:,2)) - min(XinC_lab(:,2))) / (ngrid-1);
step3 = (max(XinC_lab(:,3)) - min(XinC_lab(:,3))) / (ngrid-1);
ths_grid_a_red = min(XinC_lab(:,2)) : step2 : max(XinC_lab(:,2));
ths_grid_b_red = min(XinC_lab(:,3)) : step3 : max(XinC_lab(:,3));

% Compute the ratio of pixels found in the signal and outside of them for
% each combination of thresholds, and the percentage of pixels found
% inside:
[ratios_red, percenin_array_red] = RBT_compute_matrices_4ths(ths_grid_a_red, ths_grid_b_red, ...
                                     npixels, XinC_lab, XoutC_lab);

% Save the matrices with the results for the whole grid of thresholds:
save('RBT_matrices_red', 'ratios_red', 'percenin_array_red', 'ths_grid_a_red', 'ths_grid_b_red')


return

end


