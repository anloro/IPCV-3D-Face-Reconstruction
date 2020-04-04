function [disparityMap] = disparityMap(imLeft,imRight,disparityRange)
%DISPARITYMAP Create the disparity map of 2 images

figure
imshow(imLeft);
figure
imshow(imRight);

imLeftGray = rgb2gray(imLeft);
imRightGray = rgb2gray(imRight);

disparityMap = disparityBM(imLeftGray,imRightGray,...
    'DisparityRange', disparityRange, ...
    'UniquenessThreshold', 1, ...
    'ContrastThreshold', 0.5, ...
    'DistanceThreshold',5, ...
    'BlockSize', 5);
disparityMap(imcomplement(imLeftGray > 0)) = 0;
% Clear noise
disparityMap = medfilt2(disparityMap, [80 80],'symmetric');

% Remove holes 
disparityMap = imfill(disparityMap, 'holes');

% Plot Disparity map
figure;
imshow(disparityMap, disparityRange);
colormap(jet);
colorbar;

end