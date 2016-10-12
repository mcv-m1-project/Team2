function [lowth2, highth2, lowth3, highth3] = find_segmentation_4ths(th2_vec, th3_vec, ...
                                              min_percenin, npixels, Xin_lab, Xout_lab)


ratios = zeros(length(th2_vec), length(th3_vec), length(th2_vec), length(th3_vec));
percenin_array = zeros(length(th2_vec), length(th3_vec), length(th2_vec), length(th3_vec));
for i = 1:(length(th2_vec)-1)
    lowth2 = th2_vec(i);
    for j = 1:(length(th3_vec)-1)
        lowth3 = th3_vec(j);
        for k = (i+1):length(th2_vec)
            highth2 = th2_vec(k);
            for l = (j+1):length(th3_vec)
                highth3 = th3_vec(l);

                nin = sum(Xin_lab(:,2) > lowth2 & Xin_lab(:,2) < highth2 |...
                          Xin_lab(:,3) > lowth3 & Xin_lab(:,3) < highth3);
                nout = sum(Xout_lab(:,2) > lowth2 & Xout_lab(:,2) < highth2 |...
                           Xout_lab(:,3) > lowth3 & Xout_lab(:,3) < highth3);

                ratios(i,j,k,l) = nin / nout;
                percenin_array(i,j,k,l) = 100 * nin / npixels;
            end
        end
    end
end

% Look for the maximum ratio:
maxratio = 0;
for i = 1:(length(th2_vec)-1)
    for j = 1:(length(th3_vec)-1)
        for k = (i+1):length(th2_vec)
            for l = (j+1):length(th3_vec)
                if(percenin_array(i,j,k,l) > min_percenin)
                    if(ratios(i,j,k,l) > maxratio)
                        imax = i;
                        jmax = j;
                        kmax = k;
                        lmax = l;
                        maxratio = ratios(i,j,k,l);
                    end
                end
            end
        end
    end
end
fprintf('\nMaximum ratio found: %f\n', maxratio)
fprintf('It corresponds with the following thresholds:\n')
fprintf('%f < a < %f\n', th2_vec(imax), th2_vec(kmax))
fprintf('%f < b < %f\n', th3_vec(jmax), th3_vec(lmax))

lowth2 = th2_vec(imax);
highth2 = th2_vec(kmax);
lowth3 = th3_vec(jmax);
highth3 = th3_vec(lmax);

return

end