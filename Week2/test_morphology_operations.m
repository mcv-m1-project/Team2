%Test erode

%read some mask
BinaryImage = imread('signal_mask_test.png');

structure_element = [0 1 0; 1 1 1; 0 1 0];

myErodedImg = my_erode(BinaryImage(:,:,1),structure_element);
matlabErodedImg = imerode(BinaryImage(:,:,1),structure_element);

figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myErodedImg, [0, 1]), title('My erode')
subplot(1,3,3)
imshow(matlabErodedImg, [0, 1]), title('Matlab erode');

myDilatedImg = my_dilation(BinaryImage(:,:,1),structure_element);
matlabDilatedImg = imdilate(BinaryImage(:,:,1),structure_element);

figure,
subplot(1,3,1)
imshow(BinaryImage, [0, 1]), title('Original')
subplot(1,3,2)
imshow(myDilatedImg, [0, 1]), title('My dilation')
subplot(1,3,3)
imshow(matlabDilatedImg, [0, 1]), title('Matlab dilation');