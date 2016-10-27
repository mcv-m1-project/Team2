%%%%%%%%%%%%%%%%%%%%%%%%%
%%% *****

clear all
close all

% Base path:
dirbase = pwd;
% Path do data set:
dirimage = [dirbase, '\..\..\train'];
% Path to Ground Truth annotations:
dirgt = [dirimage, '\gt'];
% Path to Masks:
dirmask = [dirimage, '\mask'];

% We add the path where some scripts are.
addpath([dirbase, '\segmentation_methods\'])
addpath('..\Week1\')
addpath('..\Week2\')
addpath('auxiliar\')
addpath('..\evaluation\')

% Load signals vector.
load('signals_workspace');

% Train / validation split:
[trainSet, validationSet] = train_validation_split_mod(dirimage, nrepetitions);


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% Method choice:
% method = 'mod2_3groups';
method = 'RBT';

% Loading parameters and defining run function:
if(strcmp(method,'mod2_3groups'))
    load('bp_mod2_3groups_params.mat')
    runfun = @run_mod2_3groups;
    
elseif(strcmp(method,'RBT'))
    load('RBT_thresholds_blue.mat')
    load('RBT_thresholds_red.mat')
    params.thresholds_blue = thresholds_blue;
    params.thresholds_red = thresholds_red;
    params.colorspace = 'lab';
    runfun = @RBT_mask;
    
else
    error('Method not recognized.')
end


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% Get a mask, and compute connected components labeling.
n = floor(rand() * length(validationSet)) + 1;
imagefile = [dirimage, '\', validationSet{n}, '.jpg'];
image = imread(imagefile);
mask = runfun(image, params);

figure()
subplot(1,2,1)
imshow(image)
title(validationSet{n})
subplot(1,2,2)
imshow(mask, [0 1])
title('mask')

% Connected components:
CC = bwconncomp(mask);

% Get some properties of the connected components:
CCproperties = regionprops(CC, 'Area', 'BoundingBox');

% Clean the mask eliminating the componets which bounding box has an area
% lower than... min_area
% min_area = 200;
% newCC = CC;
% newCC.NumObjects = 0;
% newCC.PixelIdxList = cell(0);
% for i = 1:CC.NumObjects
%     if(CCproperties(i).BoundingBox(3) * CCproperties(i).BoundingBox(4) > min_area)
%         newCC.NumObjects = newCC.NumObjects + 1;
%         newCC.PixelIdxList{newCC.NumObjects} = CC.PixelIdxList{i};
%     end
% end
% newCCproperties = regionprops(newCC, 'Area', 'BoundingBox', 'FilledImage');

% Clean the mask eliminating the componets which bounding box has any side
% lower than... min_side
min_side = 15;
newCC = CC;
newCC.NumObjects = 0;
newCC.PixelIdxList = cell(0);
for i = 1:CC.NumObjects
    if(CCproperties(i).BoundingBox(3) > min_side && CCproperties(i).BoundingBox(4) > min_side)
        newCC.NumObjects = newCC.NumObjects + 1;
        newCC.PixelIdxList{newCC.NumObjects} = CC.PixelIdxList{i};
    end
end
newCCproperties = regionprops(newCC, 'Area', 'BoundingBox', 'FilledImage', 'Image');

% New mask without the discarded parts:
cleanmask = zeros(size(mask));
for i = 1:newCC.NumObjects
    x = floor(newCCproperties(i).BoundingBox(1));
    y = floor(newCCproperties(i).BoundingBox(2));
    w = newCCproperties(i).BoundingBox(3);
    h = newCCproperties(i).BoundingBox(4);
    cleanmask(y+1:y+h, x+1:x+w) = newCCproperties(i).Image;
end
figure()
subplot(1,2,1)
imshow(mask, [0 1])
subplot(1,2,2)
imshow(cleanmask, [0 1])


% Plot in the image the resulting bounding boxes:
figure()
imshow(mask, [0 1])
hold on
for i = 1:newCC.NumObjects
    x = newCCproperties(i).BoundingBox(1);
    y = newCCproperties(i).BoundingBox(2);
    w = newCCproperties(i).BoundingBox(3);
    h = newCCproperties(i).BoundingBox(4);
    plot([x x], [y y+h], 'y')
    plot([x+w x+w], [y y+h], 'y')
    plot([x x+w], [y y], 'y')
    plot([x x+w], [y+h y+h], 'y')
end


% Substitute the connected components for the filled versions:
filledmask = mask;
for i = 1:newCC.NumObjects
    x = floor(newCCproperties(i).BoundingBox(1));
    y = floor(newCCproperties(i).BoundingBox(2));
    w = newCCproperties(i).BoundingBox(3);
    h = newCCproperties(i).BoundingBox(4);
    filledmask(y+1:y+h, x+1:x+w) = newCCproperties(i).FilledImage;
end
figure()
subplot(1,2,1)
imshow(mask, [0 1])
subplot(1,2,2)
imshow(filledmask, [0 1])





