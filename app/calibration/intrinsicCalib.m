% Computes intrinsic calibration based on input images
% calibImgPaths: Pathvector to input images
% tileSize: Checkerboard tile size
% untes: Calibration units (m or mm)

function [cameraParams, imagesUsed, correctedPoses, estimationErrors] = intrinsicCalib(calibImgPaths, tileSize, units)

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(calibImgPaths, 'showProgressBar', 1);
calibImgPaths = calibImgPaths(imagesUsed); %checken!!!

% Generate world coordinates of the corners of the squares
% in units
worldPoints = generateCheckerboardPoints(boardSize, tileSize);

% Load one image to get size
img = imread(calibImgPaths{1});
imgSize = size(img);

% Calibrate the camera
[cameraParams, imagesUsedErrors, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', true, 'EstimateTangentialDistortion', true, ...
    'NumRadialDistortionCoefficients', 3, 'WorldUnits', units, ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], 'ImageSize', imgSize(1:2));

    % Remove all images depending on errors
    j = 1;
    for i = 1:length(imagesUsed)
        if (imagesUsed(i))
            if (imagesUsedErrors(j) == 0)
                imagesUsed(i) = 0;
            end
            j = j + 1;
        end
    end
    
   
    total = size(imagesUsedErrors, 1);
    h = waitbar(0, ['Adjusting extrinsics for image: 1 of ' num2str(total)],...
                    'Name', 'Undistorting image origins');
    % Undistort image origins                
    for i = 1:total
        waitbar(i/total, h, ['Adjusting extrinsics for image: ' num2str(i) ' of ' num2str(total)]);
        if imagesUsedErrors(i)
            orgImg = imread(calibImgPaths{i});
            
            [img, newOrigin] = undistortImage(orgImg, cameraParams, 'OutputView', 'full');
            
            [imagePoints(:,:,i), ~] = detectCheckerboardPoints(img);
            
            imagePoints(:,:,i) = [imagePoints(:,1, i) + newOrigin(1), ...
                imagePoints(:,2,i) + newOrigin(2)];
            % Save new calibration data
            [correctedOrientationMatrix, correctedTranslationVector] = extrinsics(...
                imagePoints(:,:,i), worldPoints, cameraParams);
            correctedPoses.correctedOrientationMatrix(:,:,i) = correctedOrientationMatrix;
            correctedPoses.correctedTranslationVector(:,:,i) = correctedTranslationVector;
           
        end
    end
    delete(h);
end

