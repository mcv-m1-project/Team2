function [ImgOut] = my_tophat(ImgIn, StructureElement)
%MY_TOPHAT Summary of this function goes here
%   Performs the topHat of the input image using the given structure
%   element
ImgAux = my_opening(ImgIn, StructureElement);
ImgOut = double(ImgIn) - ImgAux;

end

