function [disparityMap] = disparityMap(imLeft,imRight,disparityRange)
%DISPARITYMAP Create the disparity map of 2 images

imLeftGray = rgb2gray(imLeft);
imRightGray = rgb2gray(imRight);

%  Old function
%{
disparityMap = disparity(imLeftGray,imRightGray,...
    'DisparityRange', disparityRange, ...
    'UniquenessThreshold', 1, ...
    'ContrastThreshold', 0.7, ...
    'DistanceThreshold',10, ...
    'BlockSize', 9);
%}

% Computing Disparity Map Using Semi-Global Matching
disparityMap = disparitySGM(imLeftGray,imRightGray,...
    'DisparityRange', disparityRange, ...
    'UniquenessThreshold', 1);

% Replace all NaN values by 0
disparityMap(isnan(disparityMap)) = 0;
% Apply mask
disparityMap(imcomplement(imLeftGray > 0)) = 0;

% Clear noise
disparityMap = medfilt2(disparityMap, [60 60], 'symmetric');

% Remove holes 
disparityMap = imfill(disparityMap, 'holes');

% Plot Disparity map
figure;
imshow(disparityMap, disparityRange);
colormap(jet);
colorbar;

end