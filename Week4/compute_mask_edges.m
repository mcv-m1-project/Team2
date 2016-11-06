function mask = compute_mask_edges(windowCandidates, image)

mask = zeros(size(image));

for window = windowCandidates
    x = window.x;
    y = window.y;
    w = window.w;
    h = window.h;
    mask(y:y+h-1, x:x+w-1) = image(y:y+h-1, x:x+w-1);
end

return

end