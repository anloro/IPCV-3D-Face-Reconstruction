function [outputMask] = skin_detection(im)
% SKIN_DETECTION
% Return a mask of the skin of the subject

% Get dimensions
height = size(im, 1);
width = size(im, 2);

%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(im);

Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

% Detect Skin based on experimental values normalized and create mask
binaryImage = Cb>=77/235 & Cb<=127/235 & Cr>=133/240 & Cr<=173/240;

% Correct bad detections because of bad ilumination
se = strel('square',30);
dil = imdilate(binaryImage,se);
% imshow(dil)

% Fill holes 
binaryImage = imfill(dil, 'holes');
% imshow(binaryImage)

% Remove tiny regions.
binaryImage = bwareaopen(binaryImage, 5000);

% Extract the largest area
outputMask = bwareafilt(binaryImage, 1);
imshow(outputMask)

% Display the image.
%figure
%imshow(outputMask);
%title('Skin Mask', 'FontSize', 20);

end