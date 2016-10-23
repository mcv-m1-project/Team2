function fhat = kde2d(X, h, kernelname, gridx, gridy, percen_data)

fprintf('\nComputing kernel density estimation...\n')

% Select data to compute density estimation:
npixelstotal = size(X, 1);
if(percen_data ~= 100)
    sizereduced = round(percen_data / 100 * npixelstotal);
    Xreduced = zeros(sizereduced, 2);
    for i = 1:sizereduced
        n = floor(rand() * npixelstotal) + 1;
        Xreduced(i,:) = X(n,:);
    end
else
    Xreduced = X;
end

if(strcmp(kernelname, 'naive'))
    kernel = @kde_naive;
elseif(strcmp(kernelname, 'gaussian'))
    kernel = @kde_gaussian;
else
    error('Kernel name not recognized.')
end

nbinsx = length(gridx);
nbinsy = length(gridy);
npixels = size(Xreduced, 1);

fhat = zeros(nbinsx, nbinsy);

progress = 10;
fprintf('Completado 0%%\n')
for i = 1:nbinsx
    if(i > progress / 100 * nbinsx)
        fprintf('Completado %i%%\n', progress)
        progress = progress + 10;
    end
    x = gridx(i);
    for j = 1:nbinsy
        y = gridy(j);
        fhat(i,j) = 0;
        for pixel = 1:npixels
            fhat(i,j) = fhat(i,j) + kernel(([x, y] - Xreduced(pixel,:)) / sqrt(h));
        end
        fhat(i,j) = fhat(i,j) / (npixels * h);
    end
end
fprintf('Completado 100%%\n\n')

return

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function K = kde_naive(x)

K = (abs(x(1)) < 0.5) * (abs(x(2)) < 0.5);

return

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function K = kde_gaussian(x)

K = exp(-(x(1)^2 + x(2)^2) / 2) / (2 * pi);

return

end



