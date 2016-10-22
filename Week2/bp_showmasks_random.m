function bp_showmasks_random(image_list, dirimage)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show the masks of the three methods on a random image


n = floor(rand() * length(image_list)) + 1;
imagefile = [dirimage, '\', image_list{n}, '.jpg'];
image = imread(imagefile);




return

end
