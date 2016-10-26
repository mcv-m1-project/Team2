%%%%% MCV - M1
%%%%% Project - Task 3
%%%%% Xián López Álvarez
%%%%% Creado 12/10/2016
%%%%% Segmentar señales por color.


clear all
close all

% Base directory:
dirbase = pwd;

% Directory of the dataset (inside train):
dirdataset = [dirbase, '\..\DataSetDelivered\train'];

% Path to Ground Truth annotations:
dirgt = [dirdataset, '\gt'];

% Path to Masks:
dirmask = [dirdataset, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\evaluation'])

% Create lists with the ground truth annotations files, the mask files, and
% the original image files:
[gt_list, mask_list, image_list] = create_files_list(dirdataset);

% We read the dataset, creating a vector of objects with all the
% information about each signal:
signals = create_signal_objects(dirgt, gt_list, dirmask, mask_list, dirdataset, image_list);

% To handle more easily the filling_ratio and the form_factor, we put them
% in two vectors. By the way, we detect the signals that have no mask.
[filling_ratio, form_factor] = get_fr_ff(signals);

% We just consider the signals which have a well defined mask:
signals = signals(filling_ratio ~= 0);

% See the different types of signals, and count how many times they appear:
[signals_list, nrepetitions] = count_signals_types(signals);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [Xin, Xout] = create_Xin_Xout(signalsF, image_list, dirdataset, mask_list, dirmask);
% 
% % Convert to Lab, from RGB in [0,1]:
% npixels = size(Xin,1);
% Xin_lab = rgb2lab(Xin/ 255);
% Xout_lab = rgb2lab(Xout/ 255);
% 
% % Study over a grid:
% ntrials = 10;
% step2 = (max(Xin_lab(:,2)) - min(Xin_lab(:,2))) / (ntrials-1);
% step3 = (max(Xin_lab(:,3)) - min(Xin_lab(:,3))) / (ntrials-1);
% th2_vec = min(Xin_lab(:,2)) : step2 : max(Xin_lab(:,2));
% th3_vec = min(Xin_lab(:,3)) : step3 : max(Xin_lab(:,3));
% min_percenin = 15;
% [lowth2, highth2, lowth3, highth3] = find_segmentation_4ths(th2_vec, th3_vec, ...
%                                      min_percenin, npixels, Xin_lab, Xout_lab);
% 
% % Check on a random image:
% check_segmentation_4ths(lowth2, highth2, lowth3, highth3, image_list, dirdataset)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ahora voy a separar el vector de señales según el tipo de señal,
% obteniendo un vector para cada tipo.

for i = 1:length(signals)
    tipos{i} = signals(i).type;
end

conta = 0;
for i = 1:length(signals)
    if(signals(i).type == 'A')
        conta = conta + 1;
        signalsA(conta) = signals(i);
    end
end

conta = 0;
for i = 1:length(signals)
    if(signals(i).type == 'B')
        conta = conta + 1;
        signalsB(conta) = signals(i);
    end
end

conta = 0;
for i = 1:length(signals)
    if(signals(i).type == 'C')
        conta = conta + 1;
        signalsC(conta) = signals(i);
    end
end

conta = 0;
for i = 1:length(signals)
    if(signals(i).type == 'D')
        conta = conta + 1;
        signalsD(conta) = signals(i);
    end
end

conta = 0;
for i = 1:length(signals)
    if(signals(i).type == 'E')
        conta = conta + 1;
        signalsE(conta) = signals(i);
    end
end

conta = 0;
for i = 1:length(signals)
    if(signals(i).type == 'F')
        conta = conta + 1;
        signalsF(conta) = signals(i);
    end
end


% Aquí puedo ver un mosaico con unas cuantas señales del tipo seleccionado.
figure()
for i = 1:5
    for j = 1:5
        idx = 5*(i-1)+j;
        subplot(5,5,idx)
        imshow(signalsB(idx).image)
    end
end

% En A hay rojo y algo de amarillo.
% En B hay rojo y algo de azul. Pocas imágenes.
% El rojo se ajusta con C.
% El azul se ajusta con D.
% En E hay azul y rojo.
% En F hay azul. Las F son cuadradas: no hay colores "ruido".

% Decido hacer una segmentación para el rojo y otra para el azul, y
% juntarlas luego. 

%%%%%%% azul
[XinF, XoutF] = create_Xin_Xout(signalsF, image_list, dirdataset, mask_list, dirmask);

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

                                 
%%%%%%% vermello
[XinC, XoutC] = create_Xin_Xout(signalsC, image_list, dirdataset, mask_list, dirmask);

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


% Check on a random image:
check_segmentation_2x4ths(thresholds_blue, thresholds_red, image_list, dirdataset)


