function RBT_select(min_percenin_blue, min_percenin_red)

% Blue:
load('RBT_matrices_blue.mat');
thresholds_blue = RBT_select_4ths(ths_grid_a_blue, ths_grid_b_blue, ratios_blue, ...
                                  percenin_array_blue, min_percenin_blue);
save('RBT_thresholds_blue', 'thresholds_blue')

% Red:
load('RBT_matrices_red.mat');
thresholds_red = RBT_select_4ths(ths_grid_a_red, ths_grid_b_red, ratios_red, ...
                                 percenin_array_red, min_percenin_red);
save('RBT_thresholds_red', 'thresholds_red')

return

end