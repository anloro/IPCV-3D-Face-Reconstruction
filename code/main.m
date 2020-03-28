clear
close all

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

% Images acquisition
I_Left = imread("images/subject1/subject1Left/subject1_Left_1.jpg");
I_Middle = imread("images/subject1/subject1Middle/subject1_Middle_1.jpg");
I_Right = imread("images/subject1/subject1Right/subject1_Right_1.jpg");

% Rectification of the images
[I_Left_Recti, I_LeftMid_Recti] = rectifyStereoImages(I_Left, I_Middle, stereoParamLtM);
[I_MidRight_Recti, I_Right_Recti] = rectifyStereoImages(I_Middle, I_Right, stereoParamMtR);

% Colour normalization script
I1 = imread("images/subject1/subject1Middle/subject1_Middle_1.jpg");
I2 = imread("images/subject1/subject1Middle/subject1_Middle_364.jpg");
[Inorm1, Inorm2] = colourNorm(I1,I2);
figure; imshow(Inorm1)
figure; imshow(Inorm2)
