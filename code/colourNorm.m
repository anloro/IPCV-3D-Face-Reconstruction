function [Inorm1, Inorm2, Inorm3] = colourNorm(I1,I2,I3)
% This function gets 2 images and computes the mean and standard deviation
% for each channel of both images together. Then it uses these parameters
% to normalize the images and return them.

% Let's assume that the images are of the same size
    I1 = double(I1); % The functions need double data type
    I2 = double(I2);
    I3 = double(I3);
    [n,m,ch] = size(I1);
    Inorm1 = zeros(n,m,ch);
    Inorm2 = zeros(n,m,ch);
    Inorm3 = zeros(n,m,ch);
    mn = ones(ch,1);
    st = ones(ch,1);
    for ii = 1:ch % For each channel
        a = [I1(:,:,ii) I2(:,:,ii)]; % Consider the values in both images
        aa = reshape(a,[n*m*2 1]);
        mn(ii) = mean(aa); % Compute the global mean
        st(ii) = std(aa); % Compute the global standard deviation
        minI = mn(ii)-st(ii); % Use the computed values for the margins
        maxI = mn(ii)+st(ii);
        Inorm1(:,:,ii) = mat2gray(I1(:,:,ii),[minI maxI]); % Normalize
        Inorm2(:,:,ii) = mat2gray(I2(:,:,ii),[minI maxI]); % Normalize
        Inorm3(:,:,ii) = mat2gray(I3(:,:,ii),[minI maxI]); % Normalize
    end
end