function [CC_list]  = week3_task1(dirmask, outdir)
%function to calculate connected components
%input: mask dir
%output: list with the connected components for each image
load('signals_main_parameters');

% Check for existence of outdir. If not, create it:
if(exist(outdir, 'dir') ~= 7)
    mkdir(outdir)
end

%get the max and min filling ratio
min_fr = min(filling_ratio);
max_fr = max(filling_ratio);

%get the max and min form factor
min_ff = min(form_factor);
max_ff = max(form_factor);

minimum_size = min(min_size); %get the minimun of the 6 types of signals
maximum_size = max(max_size); %get the minimun of the 6 types of signals

mask_file_list = listFiles(dirmask);
n_mask = length(mask_file_list);    % Number of files found
n_mask
CC_list = cell(0);

for i=1:n_mask
    mask_file = [dirmask, '\', mask_file_list(i).name];
    current_mask = imread(mask_file);
    
    % Connected components:
    CC = bwconncomp(current_mask);
    % Get some properties of the connected components:
    CCproperties = regionprops(CC, 'Extent', 'BoundingBox');%Extent: area / boundingbox_area
    
    %for each mask, creating an object of cc that pass the filter
    newCC = CC;
    newCC.NumObjects = 0;
    newCC.PixelIdxList = cell(0);
    
    for j = 1:CC.NumObjects %analyze all the cc found in the mask
        
        current_width=CCproperties(j).BoundingBox(3);%width of the connect component's bounding box
        current_height=CCproperties(j).BoundingBox(4);%height of the connect component's bounding box
        
        current_fr = CCproperties(j).Extent;%filling ratio of the current connect component
        current_ff = current_width/current_height;%form factor of the current connect component
           
        current_size = current_width*current_height;
        
        %filter based of filling ratio and form factor
        if (current_fr>=min_fr & current_fr<=max_fr & ... 
           current_ff>=min_ff & current_ff<=max_ff &...
           current_size>=minimum_size & current_size<=maximum_size)
       
            %store cc
            newCC.NumObjects = newCC.NumObjects + 1;
            newCC.PixelIdxList{newCC.NumObjects} = CC.PixelIdxList{j};
        end
    end
    
    
    newCCproperties = regionprops(newCC, 'BoundingBox', 'Image');
       
    CC_list{i}=newCC; %save the final cc for each mask
   
     windowCandidates = struct('x', [], 'y', [], 'w',[], 'h', []);
    
    % Clean mask: It has only the connected components that we previously
    % accepted:
    clean_mask = zeros(size(current_mask));
    for j = 1:newCC.NumObjects
        x = floor(newCCproperties(j).BoundingBox(1));
        y = floor(newCCproperties(j).BoundingBox(2));
        w = newCCproperties(j).BoundingBox(3);
        h = newCCproperties(j).BoundingBox(4);
        %clean mask
        clean_mask((y+1):(y+h), (x+1):(x+w)) = newCCproperties(j).Image;
        %fill windowCandidates
        windowCandidates(j).x=x;
        windowCandidates(j).y=y;
        windowCandidates(j).w=w;
        windowCandidates(j).h=h;
    end
    
    % Write mask:
    imwrite(clean_mask, [outdir, '\', mask_file_list(i).name])
        
    %save mat of windows candidates
    save(strcat(outdir,'\',mask_file_list(i).name(1:end-4),'.mat'),'windowCandidates');
    
%     % % VISUALIZATION
%     % Plot in the image the resulting bounding boxes:
%     figure()
%     imshow(current_mask, [0 1])
%     hold on
%     for j = 1:newCC.NumObjects
%         x = newCCproperties(j).BoundingBox(1);
%         y = newCCproperties(j).BoundingBox(2);
%         w = newCCproperties(j).BoundingBox(3);
%         h = newCCproperties(j).BoundingBox(4);
%         plot([x x], [y y+h], 'y')
%         plot([x+w x+w], [y y+h], 'y')
%         plot([x x+w], [y y], 'y')
%         plot([x x+w], [y+h y+h], 'y')
%     end
%     w = waitforbuttonpress;
    
end

end