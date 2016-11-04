clearvars
close all

X = zeros(15,12);
X(5,:) = 1;
XDT = bwdist(X);

height = 5;
width = 7;

rowcenter = floor((height + 1) / 2);
colcenter = floor((width + 1) / 2);

template = round(rand(height,width));

% template_filtro = template(end:-1:1, end:-1:1);
% convolucion = conv2(XDT,template_filtro,'same');

convolucion = filter2(template,XDT,'same');

n = 6;
m = 3;
subIm = XDT(n:n+height-1, m:m+width-1);


score = sum(sum(subIm .* template))

convolucion(n+rowcenter-1, m+colcenter-1)








