function [M_ABC, M_DF, M_E, R1_ABC, R1_DF, R1_E, gridx, gridy] = ...
    train_mod2_3groups(trainSet, validationSet, dirimage, dirmask, signals, nbins, colorspace)


% Create separate lists for each group of signals:
[trainABC, trainDF, trainE] = separate_list_groups(trainSet, signals);
[validationABC, validationDF, validationE] = separate_list_groups(validationSet, signals);

% Create train and validation signals vectors for each group:
% ABC:
[signals_ABC_train, ~] = separate_signals_train(trainABC, validationABC, signals);
% DF:
[signals_DF_train, ~] = separate_signals_train(trainDF, validationDF, signals);
% E:
[signals_E_train, ~] = separate_signals_train(trainE, validationE, signals);

% Grids:
[gridx, gridy] = histograms_create_grids(nbins, colorspace);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  ABC  training

% Create matrices with pixels in and outside train signals:
[Xin, Xout] = create_Xin_Xout(signals_ABC_train, trainABC, dirimage, dirmask);

% Training backprojection:
[M_ABC, R1_ABC] = backprojection_mod2_train(gridx, gridy, colorspace, Xin, Xout, 0, 0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  DF  training

% Create matrices with pixels in and outside train signals:
[Xin, Xout] = create_Xin_Xout(signals_DF_train, trainDF, dirimage, dirmask);

% Training backprojection:
[M_DF, R1_DF] = backprojection_mod2_train(gridx, gridy, colorspace, Xin, Xout, 0, 0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  E  training

% Create matrices with pixels in and outside train signals:
[Xin, Xout] = create_Xin_Xout(signals_E_train, trainE, dirimage, dirmask);

% Training backprojection:
[M_E, R1_E] = backprojection_mod2_train(gridx, gridy, colorspace, Xin, Xout, 0, 0);

return

end