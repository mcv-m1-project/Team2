function [Xin, Xout] = create_Xin_Xout(signals, fileslist, dirdataset, dirmask)

% Count pixels in signals:
Xin = [];
for count = 1:length(signals)
    Xsignal = zeros(size(signals(count).image, 1) * size(signals(count).image, 2), 3);
    idx = 0;
    for i = 1:size(signals(count).image, 1)
        for j = 1:size(signals(count).image, 2)
            idx = idx + 1;
            Xsignal(idx,:) = signals(count).image(i, j, :);
        end
    end
    Xin = [Xin; Xsignal];
end

% Count pixels out of signals (random sample):
nimages = length(fileslist);
npixels = size(Xin, 1);
npixelsperimage = round(npixels / nimages); % Number of pixels to sample from each image.
nppi_vec = zeros(nimages); % Vector with the number of pixels to sample in each image (the last one may differ).
nppi_vec(1:(nimages-1)) = npixelsperimage;
nppi_vec(nimages) = npixels - npixelsperimage * (nimages - 1);
Xout = zeros(npixels, 3); % We will sample outside as many pixels as inside.
row = 0;
for file = 1:nimages
    image = imread([dirdataset, '\', fileslist{file}, '.jpg']);
    mask = imread([dirmask, '\mask.', fileslist{file}, '.png']);
    sizex = size(image, 1);
    sizey = size(image, 2);
    count = 0;
    while count < nppi_vec(file)
        i = floor(rand() * sizex) + 1;
        j = floor(rand() * sizey) + 1;
        if(mask(i,j) == 0) % This means the pixel does not belong to a signal.
            count = count + 1;
            row = row + 1;
            Xout(row, :) = image(i, j, :);
        end
    end
end

return

end