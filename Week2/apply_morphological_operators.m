function out_mask = apply_morphological_operators(in_mask, signals_size)
%apply_morphological_operators
%   Apply morphological operators to the input mask
%
%   Parameters
%       'in_mask' - Input mask image
%       'signals_size' - Signal size parameters
%   Return
%       'out_mask' - Output mask image

%subplot(2,2,1), imshow(in_mask, [0,1]), title('input mask')

%Apply imclose first to define better the signal borders
se = strel('square', 5);
out_mask = imclose(in_mask, se);

%Fill image holes
out_mask = imfill(out_mask,'holes');
%subplot(2,2,2), imshow(out_mask, [0,1]), title('fill holes')

%Apply and area opening for the binary mask to the small and big areas that
%cannot be traffic signals
% out_mask = bwareaopen(out_mask, signals_size.min_area);
% aux_out_mask = bwareaopen(out_mask, signals_size.max_area);
% out_mask = out_mask - aux_out_mask;
% subplot(2,2,3), imshow(out_mask, [0,1]), title('bwareaopen')

el = strel('rectangle', floor([signals_size.min_height signals_size.min_width]));
aux_out_mask_min = imopen(out_mask, el);

el = strel('rectangle', floor([signals_size.max_height signals_size.max_width]));
aux_out_mask_max = imopen(out_mask, el);
out_mask = aux_out_mask_min | aux_out_mask_max;

%subplot(2,2,4), imshow(out_mask, [0,1]), title('imopen')

end