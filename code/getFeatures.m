function features = getFeatures(I1, I2)
% This function extracts and matches features between 2 images

    I1 = rgb2gray(I1); % Change image to gray scale
    I2 = rgb2gray(I2); % Change image to gray scale
    
    L_points = detectORBFeatures(I1,'NumLevels', 8); % Detect features
    [features1,validPoints1] = extractFeatures(I1,L_points); % Extract features

    M_points = detectORBFeatures(I2,'NumLevels', 8); % Detect features
    [features2,validPoints2] = extractFeatures(I2,M_points); % Extract features

    % Feature matching
    indexPairs = matchFeatures(features1,features2,...
        'MaxRatio', 0.6, 'MatchThreshold', 10);
    matchedPoints1 = validPoints1(indexPairs(:,1),:);
    matchedPoints2 = validPoints2(indexPairs(:,2),:);
    % Show matched features
%     figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    
    % Get inliers 
    [fMatrix, epipolarInliers] = estimateFundamentalMatrix(...
      matchedPoints1, matchedPoints2, 'Method', 'MSAC', 'NumTrials', 100000,...
      'DistanceThreshold', 0.01, 'InlierPercentage', 85);
    features.fMatrix = fMatrix;
    figure;
    showMatchedFeatures(I1, I2, matchedPoints1(epipolarInliers,:),...
        matchedPoints2(epipolarInliers,:),'montage','PlotOptions',{'ro','go','y--'});
    title('Point matches after outliers were removed');
    
    % Find epipolar inliers
    features.inlierPoints1 = matchedPoints1(epipolarInliers, :);
    features.inlierPoints2 = matchedPoints2(epipolarInliers, :);

end