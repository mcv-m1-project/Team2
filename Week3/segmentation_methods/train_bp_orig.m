function [M_ABC, M_DF, M_E] = train_bp_orig(signals, nbins, colorspace)


% Create grids, depending on the colorspace chosen:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);

% Case ABC:


save('bp_orig_Ms.mat', 'M_ABC', 'M_DF', 'M_E')

return

end