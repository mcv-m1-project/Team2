function [recall, precision] =week1_task4(test_mask, gt_mask)

tp=0; 
tn=0; 
fp=0; 
fn=0;

[ni, nj] = size(test_mask);
for j=1:nj
    for i=1:ni
        if(test_mask(i,j)==1 & gt_mask(i,j)==1)
            tp=tp+1;
        elseif(test_mask(i,j)==0 & gt_mask(i,j)==0)
            tn=tn+1;
        elseif(test_mask(i,j)==1 & gt_mask(i,j)==0)
            fp=fp+1;
        elseif(test_mask(i,j)==0 & gt_mask(i,j)==1)
            fn=fn+1;
        end
    end
end
recall =  tp / (tp + fn);
precision = tp / (tp + fn);

end