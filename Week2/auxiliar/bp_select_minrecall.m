function bp_select_minrecall(min_recall, train_signals, train_image_list, dirimage, train_mask_list, dirmask)

% Selecting parameters for each method:
backprojection_sb_select(min_recall)
backprojection_mod_select(min_recall)
backprojection_kde_select(min_recall)

% Training with selected parameters:
backprojection_sb_train_final(train_signals, train_image_list, dirimage, train_mask_list, dirmask)
backprojection_mod_train_final(train_signals, train_image_list, dirimage, train_mask_list, dirmask)
backprojection_kde_train_final(train_signals, train_image_list, dirimage, train_mask_list, dirmask)

return

end