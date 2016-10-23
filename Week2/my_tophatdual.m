function [ImgOut] = my_tophatdual(ImgIn, StructureElement)
%MY_TOPHATDUAL Summary of this function goes here
%   Performs the topHat dual of the input image using the given structure
%   element
ImgAux = my_closing(ImgIn, StructureElement);
ImgOut = ImgAux - double(ImgIn);

end

