function [ windowCandidates ] = windowFind( mask )
%WINDOWFIND Summary of this function goes here
%   Detailed explanation goes here
    CC = bwconncomp(mask);
    CCproperties = regionprops(CC, 'BoundingBox');
    windowCandidates = [];
    for j = 1:CC.NumObjects
        x = floor(CCproperties(j).BoundingBox(1));
        y = floor(CCproperties(j).BoundingBox(2));
        w = CCproperties(j).BoundingBox(3);
        h = CCproperties(j).BoundingBox(4);
        
        windowCandidates = [windowCandidates; struct('x', x, 'y', y, 'w',w,'h',h);];
    end

end

