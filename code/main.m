clear
close all

addpath(genpath('functions'))
% Camera calibration
%{
Estimation of the geometric parameters of the stereo camera. It's necessary to select the same amount
of images from both perspectives in order to allow the estimation to compare them. Once the automatic
selection of points from the checkerboards had been done, it will appear the stereo pairs processed and the 
calibration will take place. The elimination of some pairs will help to reduce the reprojection errors from
both cameras. The session will be saved and paraments exported. This calibration will take place within the 
left and middle checkerboard images, and another calibration with the same process between middle and right.
%}

% stereoCameraCalibrator
load('calibration/stereoParamLtM');
load('calibration/stereoParamMtR');
load('calibration/stereoParamLmono')

% Images acquisition
% Subject 1
I_Left = imread("images/subject1/subject1Left/subject1_Left_1.jpg");
I_Middle = imread("images/subject1/subject1Middle/subject1_Middle_1.jpg");
I_Right = imread("images/subject1/subject1Right/subject1_Right_1.jpg");

% Subject 2
% I_Left = imread("images/subject2/subject2_Left/subject2_Left_1.jpg");
% I_Middle = imread("images/subject2/subject2_Middle/subject2_Middle_1.jpg");
% I_Right = imread("images/subject2/subject2_Right/subject2_Right_1.jpg");

% Colour normalization
[I_Left, I_Middle, I_Right] = colourNorm(I_Left,I_Middle, I_Right);

%% Background Removal
% Middle
back_mask = background_removal(I_Middle);
back_mask = cat(3, back_mask, back_mask, back_mask);
I_Middle_masked = I_Middle;
I_Middle_masked(imcomplement(back_mask)) = 0;
% figure; imshow(I_Middle_masked);
skin_mask = skin_detection(I_Middle_masked);
skin_mask = cat(3, skin_mask, skin_mask, skin_mask);
I_Middle_masked(imcomplement(skin_mask)) = 0;
% figure; imshow(I_Middle_masked);

% Left
back_mask = background_removal(I_Left);
back_mask = cat(3, back_mask, back_mask, back_mask);
I_Left_masked = I_Left;
I_Left_masked(imcomplement(back_mask)) = 0;
% figure; imshow(I_Left_masked);
skin_mask = skin_detection(I_Left_masked);
skin_mask = cat(3, skin_mask, skin_mask, skin_mask);
I_Left_masked(imcomplement(skin_mask)) = 0;
% figure; imshow(I_Left_masked);

% Right
back_mask = background_removal(I_Right);
back_mask = cat(3, back_mask, back_mask, back_mask);
I_Right_masked = I_Right;
I_Right_masked(imcomplement(back_mask)) = 0;
% figure; imshow(I_Right_masked);
skin_mask = skin_detection(I_Right_masked);
skin_mask = cat(3, skin_mask, skin_mask, skin_mask);
I_Right_masked(imcomplement(skin_mask)) = 0;
% figure; imshow(I_Right_masked);

%% Rectification of the images
[I_Left_Recti, I_LeftMid_Recti] = rectifyStereoImages(I_Left_masked, I_Middle_masked, stereoParLtM, 'OutputView', 'full');
[I_MidRight_Recti, I_Right_Recti] = rectifyStereoImages(I_Middle_masked, I_Right_masked, stereoParMtR, 'OutputView', 'full');
close all
% imshow(I_Left_Recti)
% imshow(I_LeftMid_Recti)
% imshow(I_MidRight_Recti)
% imshow(I_Right_Recti)

%% Stereo feature extraction
featuresLM = getFeatures(I_Left_Recti, I_LeftMid_Recti);
featuresRM = getFeatures(I_MidRight_Recti, I_Right_Recti);
%% Reconstruct 3D location of the extracted points
ptCloudLM = getPtCloud(I_Left_Recti, I_LeftMid_Recti,...
    stereoParLtM,featuresLM);
ptCloudRM = getPtCloud(I_MidRight_Recti, I_Right_Recti,...
    stereoParMtR,featuresRM);
