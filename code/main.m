clear
close all

% Colour normalization script
I1 = imread("images/subject1/subject1Middle/subject1_Middle_1.jpg");
I2 = imread("images/subject1/subject1Middle/subject1_Middle_364.jpg");
[Inorm1, Inorm2] = colourNorm(I1,I2);
figure; imshow(Inorm1)
figure; imshow(Inorm2)
