function out_mask = apply_morphological_operators(in_mask, min_size, max_size)
%apply_morphological_operators
%   Apply morphological operators to the input mask
%
%   Parameters
%       'in_mask' - Input mask image
%       'min_size' - Minimum signal size
%       'max_size' - Maximum signal size
%   Return
%       'out_mask' - Output mask image

subplot(2,2,1), imshow(in_mask, [0,1]), title('input mask')

%Apply imclose first to define better the signal borders
se = strel('square', 5);
out_mask = imclose(in_mask, se);
subplot(2,2,2), imshow(out_mask, [0,1]), title('imclose 5')

%Fill image holes
out_mask = imfill(out_mask,'holes');
subplot(2,2,3), imshow(out_mask, [0,1]), title('fill holes')

%Low threshold to clean very small areas (smaller than min signal size/2)
low_threshold = floor(min(min_size)/2);

%Upper threshold to clean very big areas (larger than max signal size)
up_threshold = floor(max(max_size));

%Apply and area opening for the binary mask to the small and big areas that
%cannot be traffic signals
out_mask = bwareaopen(out_mask, low_threshold);

aux_out_mask = bwareaopen(out_mask, up_threshold);
out_mask = out_mask - aux_out_mask;

subplot(2,2,4), imshow(out_mask, [0,1]), title('bwareaopen')

end