function ptCloud = getPtCloud(I1,I2,cameraParam,features)
    
    inlierPoints1 = features.inlierPoints1;
    inlierPoints2 = features.inlierPoints2;
    fMatrix = features.fMatrix;
    
%     I1 = undistortImage(I1, cameraParam1);
%     I2 = undistortImage(I2, cameraParam2);

%     [R, t] = relativeCameraPose(fMatrix, cameraParam2, inlierPoints1, inlierPoints2);
    % Detect dense feature points
%     imagePoints1 = detectHarrisFeatures(rgb2gray(I1), 'MinQuality', 0.001);
    imagePoints1 = detectMinEigenFeatures(rgb2gray(I1),...
        'FilterSize', 3, 'MinQuality', 0.0001);

    % Create the point tracker
    tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 4);

    % Initialize the point tracker
    imagePoints1 = imagePoints1.Location;
    initialize(tracker, imagePoints1, I1);

    % Track the points
    [imagePoints2, validIdx] = step(tracker, I2);
    matchedPoints1 = imagePoints1(validIdx, :);
    matchedPoints2 = imagePoints2(validIdx, :);

    % Compute the camera matrices for each position of the camera
    % The first camera is at the origin looking along the X-axis. Thus, its
    % rotation matrix is identity, and its translation vector is 0.
%     camMatrix1 = cameraMatrix(cameraParam1, eye(3), [0 0 0]);
%     camMatrix2 = cameraMatrix(cameraParam2, R', -t*R');
%     camMatrix2
    % Compute the 3-D points
    points3D = triangulate(matchedPoints1, matchedPoints2, cameraParam);

    % Get the color of each reconstructed point
    numPixels = size(I1, 1) * size(I1, 2);
    allColors = reshape(I1, [numPixels 3]);
    colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)), ...
        round(matchedPoints1(:, 1)));
    color = allColors(colorIdx, :);

    % Create the point cloud
    ptCloud = pointCloud(points3D, 'Color', color);
    ptCloud = pcdenoise(ptCloud);
%     ptCloud = pcdownsample(ptCloud, 'nonuniformGridSample', 15);

    %% Visualize the camera locations and orientations
    figure
    % Visualize the point cloud
    pcshow(ptCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
        'MarkerSize', 45);

    % Rotate and zoom the plot
    camorbit(0, -30);
    camzoom(1.5);

    % Label the axes
    xlabel('x-axis');
    ylabel('y-axis');
    zlabel('z-axis')

    title('3D point cloud');
end
