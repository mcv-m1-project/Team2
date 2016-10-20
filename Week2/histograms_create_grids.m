function [gridx, gridy] = histograms_create_grids(nbins, colorspace)

    
if(strcmp(colorspace, 'lab'))
    minx = -128;
    maxx = 128;
    miny = -128;
    maxy = 128;
    stepx = (maxx - minx) / (nbins - 1);
    stepy = (maxy - miny) / (nbins - 1);
    gridx = minx:stepx:maxx;
    gridy = miny:stepy:maxy;
    
elseif(strcmp(colorspace, 'hsv'))
    minx = 0;
    maxx = 360;
    miny = 0;
    maxy = 100;
    stepx = (maxx - minx) / (nbins - 1);
    stepy = (maxy - miny) / (nbins - 1);
    gridx = minx:stepx:maxx;
    gridy = miny:stepy:maxy;
    
else
    error('Color space not recognized.')
end






return

end