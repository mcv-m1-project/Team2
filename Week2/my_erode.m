function [ImgOut] = my_erode(ImgIn, StructureElement)

[SEm, SEn] = size(StructureElement);
SE_center_i = floor((SEm+1)/2);
SE_center_j = floor((SEn+1)/2);

[m, n] = size(ImgIn);
ImgOut = zeros(m,n);

StructureElement ( StructureElement==0) = NaN; %for avoiding confusions when a pixel value is 0

window = zeros(size(StructureElement));
for i=1:m
    for j=1:n
        
        [SEm, SEn] = size(StructureElement);
        
        start_i = i-SE_center_i+1;
        start_j = j-SE_center_j+1;
                
        SEi = 1;
        SEj = 1;
        for k=start_i:start_i+SEm-1
            for l=start_j:start_j+SEn-1
                if(k<=0 | k>m | l<=0 | l>n)
                    window(SEi,SEj)=ImgIn(i,j);%mirroring borders
                else
                    window(SEi,SEj)=ImgIn(k,l);
                end
                SEj = SEj + 1;
            end
            SEj = 1;
            SEi = SEi + 1;
        end
        ImgOut(i,j) = min(min(StructureElement.*window));
    end
end
end