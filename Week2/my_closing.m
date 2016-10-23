function [ImgOut] = my_closing(ImgIn, StructureElement)
%MY_CLOSING
%   Performs and opening to the input image using the given structure
%   element
ImgAux = my_dilation(ImgIn, StructureElement);
ImgOut = my_erode(ImgAux, StructureElement);

end

