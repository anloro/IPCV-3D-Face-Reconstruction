function [outputMask] = skin_detection(im)
% SKIN_DETECTION
% Return a mask of the skin of the subject

% Get dimensions
height = size(im, 1);
width = size(im, 2);

%Initialize the binary image
binaryImage = zeros(height, width);

%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(im);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

%Detect Skin
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
numind = size(r,1);

%Mark Skin Pixels
for i=1:numind
    binaryImage(r(i),c(i)) = 1;
end

binaryImage = im2bw(binaryImage, graythresh(binaryImage));

B = bwboundaries(binaryImage);
binaryImage = imfill(binaryImage, 'holes');
% Remove tiny regions.
binaryImage = bwareaopen(binaryImage, 5000);

% Extract the largest area
outputMask = bwareafilt(binaryImage, 1);

% Display the image.
%figure
%imshow(outputMask);
%title('Skin Mask', 'FontSize', 20);

end