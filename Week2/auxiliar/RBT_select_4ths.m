function thresholds = RBT_select_4ths(ths_grid_a, ths_grid_b, ratios, percenin_array, min_percenin)


fprintf('\nSelecting thresholds in matrix...\n')

% Look for the maximum ratio:
maxratio = 0;
for i = 1:(size(ratios,1)-1)
    for j = 1:(size(ratios,2)-1)
        for k = (i+1):size(ratios,3)
            for l = (j+1):size(ratios,4)
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
fprintf('%f < a < %f\n', ths_grid_a(imax), ths_grid_a(kmax))
fprintf('%f < b < %f\n', ths_grid_b(jmax), ths_grid_b(lmax))

thresholds = zeros(1,4);
thresholds(1) = ths_grid_a(imax);
thresholds(2) = ths_grid_a(kmax);
thresholds(3) = ths_grid_b(jmax);
thresholds(4) = ths_grid_b(lmax);

return

end