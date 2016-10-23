function [ImgOut] = my_opening(ImgIn, StructureElement)
%MY_OPENING
%   Performs and opening to the input image using the given structure
%   element
ImgAux = my_erode(ImgIn, StructureElement);
ImgOut = my_dilation(ImgAux, StructureElement);

end

