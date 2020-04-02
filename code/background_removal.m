function [BWfinal] = background_removal(im)
% BACKGROUND_REMOVAL
% Based on the Image Processing Toolbox
% "Detect Cell Using Edge Detection and Morphology" example
% Return a mask image of the subject without the background

%% Step 1: Transform to gray image
grayIm = rgb2gray(im);

%% Step 2: Detect Entire Cell
[~, threshold] = edge(grayIm, 'sobel');
fudgeFactor = 0.5;
BWs = ut_edge(grayIm, 'c', 's', 1.5, 't', threshold * fudgeFactor, 'h', [0.1 0.02]);
% figure
% imshow(BWs)
%title('Binary Gradient Mask')

%% Step 3: Dilate the Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);

BWsdil = imdilate(BWs,[se90 se0]);
%figure
%imshow(BWsdil)
%title('Dilated Gradient Mask')

%% Step 4: Fill Interior Gaps
BWdfill = imfill(BWsdil,'holes');
%figure
%imshow(BWdfill)
%title('Binary Image with Filled Holes')

%% Step 5: Remove Connected Objects on Border (Useless in our case, cause trouble when done)
%BWnobord = imclearborder(BWdfill, 8);
%figure
%imshow(BWnobord)
%title('Cleared Border Image')
BWnobord = BWdfill;

%% Step 6: Smooth the Object
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
%figure
%imshow(BWfinal)
%title('Segmented Image');

%% Step 7: Visualize the Segmentation
%figure
%imshow(labeloverlay(grayIm,BWfinal))
%title('Mask Over Original Image')

end

