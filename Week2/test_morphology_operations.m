%Test implemented morphological operators

%read some mask
BinaryImage = imread('signal_mask_test.png');

structure_element = [0 1 0; 1 1 1; 0 1 0];

%Test erode
tic
myErodedImg = my_erode(BinaryImage(:,:,1),structure_element);
myErodeTime = toc;
tic
matlabErodedImg = imerode(BinaryImage(:,:,1),structure_element);
matlabErodeTime = toc;
erodeCompareTime = 100*myErodeTime/matlabErodeTime;
erodeCompare =find((myErodedImg-double(matlabErodedImg))~=0);

figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myErodedImg, [0, 1]), title('My erode')
subplot(1,3,3)
imshow(matlabErodedImg, [0, 1]), title('Matlab erode');

%Test dialton
tic
myDilatedImg = my_dilation(BinaryImage(:,:,1),structure_element);
myDiltaionTime = toc;
tic
matlabDilatedImg = imdilate(BinaryImage(:,:,1),structure_element);
matlabDilationTime = toc;
dilationCompareTime = 100*myDiltaionTime/matlabEDilationTime;
dilationCompare = find((myDilatedImg-double(matlabDilatedImg))~=0);

figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myDilatedImg, [0, 1]), title('My dilation')
subplot(1,3,3)
imshow(matlabDilatedImg, [0, 1]), title('Matlab dilation');

%Test opening
tic
myOpenedImg = my_opening(BinaryImage(:,:,1),structure_element);
myOpeningTime = toc;
tic
matlabOpenedImg = imopen(BinaryImage(:,:,1),structure_element);
matlabOpeningTime = toc;
openingCompareTime = 100*myOpeningTime/matlabOpeningTime;
openingCompare=find((myOpenedImg-double(matlabOpenedImg))~=0);


figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myOpenedImg, [0, 1]), title('My opening')
subplot(1,3,3)
imshow(matlabOpenedImg, [0, 1]), title('Matlab opening');

%Test closing
tic
myClosedImg = my_closing(BinaryImage(:,:,1),structure_element);
myClosingTime = toc;
tic
matlabClosedImg = imclose(BinaryImage(:,:,1),structure_element);
matlabClosingTime = toc;
closingCompareTime = 100*myClosingTime/matlabClosingTime;
closingCompare=find((myClosedImg-double(matlabClosedImg))~=0);

figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myClosedImg, [0, 1]), title('My closing')
subplot(1,3,3)
imshow(matlabClosedImg, [0, 1]), title('Matlab closing');

%Test TopHat
tic
myTopHatImg = my_tophat(BinaryImage(:,:,1),structure_element);
myTopHatTime = toc;
tic
matlabTopHatImg = imtophat(BinaryImage(:,:,1),structure_element);
matlabTopHatTime = toc;
topHatCompareTime = 100*myTopHatTime/matlabTopHatTime;
topHatCompare=find((myTopHatImg-double(matlabTopHatImg))~=0);

figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myTopHatImg, [0, 1]), title('My TopHat')
subplot(1,3,3)
imshow(matlabTopHatImg, [0, 1]), title('Matlab TopHat');

%Test TopHat dual
tic
myTopHatDualImg = my_tophatdual(BinaryImage(:,:,1),structure_element);
myTopHatDualTime = toc;
tic
matlabTopHatDualImg = imbothat(BinaryImage(:,:,1),structure_element);
matlabTopHatDualTime = toc;
topHatDualCompareTime = 100*myTopHatDualTime/matlabTopHatDualTime;
topHatDualCompare=find((myTopHatDualImg-double(matlabTopHatDualImg))~=0);

figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myTopHatDualImg, [0, 1]), title('My TopHat dual')
subplot(1,3,3)
imshow(matlabTopHatDualImg, [0, 1]), title('Matlab TopHat Dual');