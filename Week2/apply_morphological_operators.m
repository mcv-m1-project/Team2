function out_mask = apply_morphological_operators(in_mask)
%apply_morphological_operators
%   Apply morphological operators to the input mask
%
%   Parameters
%       'in_mask' - Input mask image
%   Return
%       'out_mask' - Output mask image

%subplot(2,2,1), imshow(in_mask, [0,1]), title('input mask')

%Binary open of a 30000 pixel region to clean very big areas (larger than max signal size)
out_mask = bwareaopen(in_mask, 30000);
out_mask = in_mask - out_mask;
%subplot(2,2,2), imshow(out_mask, [0,1]), title('bwareaopen 53000')

%Apply imclose first to define better the signal borders
se = strel('square', 5);
out_mask = imclose(out_mask, se);
%subplot(2,2,3), imshow(out_mask, [0,1]), title('imclose 10')

%Fill image holes
out_mask = imfill(out_mask,'holes');
%subplot(2,2,3), imshow(out_mask, [0,1]), title('fill')

%Binary open of a 600 pixel region
out_mask = bwareaopen(out_mask, 600);
%subplot(2,2,4), imshow(out_mask, [0,1]), title('bwareaopen')

end