function [ratios, percenin_array] = RBT_compute_matrices_4ths(th2_vec, th3_vec, ...
                                              npixels, Xin_lab, Xout_lab)

fprintf('Computing matrices for thresholds grid...\n')

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

fprintf('Done.\n')

return

end