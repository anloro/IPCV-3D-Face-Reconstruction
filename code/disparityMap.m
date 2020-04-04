function [disparityMap] = disparityMap(imLeft,imRight,disparityRange)
%DISPARITYMAP Create the disparity map of 2 images

imLeftGray = rgb2gray(imLeft);
imRightGray = rgb2gray(imRight);

disparityMap = disparity(imLeftGray,imRightGray,...
    'DisparityRange', disparityRange, ...
    'UniquenessThreshold', 1, ...
    'ContrastThreshold', 0.7, ...
    'DistanceThreshold',15, ...
    'BlockSize', 5);

%disparityMap = disparitySGM(imLeftGray,imRightGray,...
%    'DisparityRange', disparityRange, ...
%    'UniquenessThreshold', 100);

disparityMap(imcomplement(imLeftGray > 0)) = 0;

% Clear noise
disparityMap = medfilt2(disparityMap, [50 50], 'symmetric');

% Remove holes 
disparityMap = imfill(disparityMap, 'holes');

% Plot Disparity map
figure;
imshow(disparityMap, disparityRange);
colormap(jet);
colorbar;

end