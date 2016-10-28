function [imgOut] =integral_image(imgIn)
    [ni, nj]=size(imgIn);
    imgOut = zeros(ni,nj);
    %initialize the first element
    imgOut(1,1) = imgIn(1,1);
    
    %for the first row
    for i=2:ni
        imgOut(i,1)=imgOut(i-1,1)+imgIn(i,1);
    end
        
    %for the first column
    for j=2:nj
        imgOut(1,j)=imgOut(1,j-1)+imgIn(1,j);
    end
    
    for j=2:nj
        for i=2:ni
            imgOut(i,j)=imgIn(i,j)+imgOut(i-1,j)+imgOut(i,j-1)-imgOut(i-1,j-1);
        end
    end
end