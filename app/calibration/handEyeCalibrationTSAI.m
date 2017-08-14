% Computes hand eye calibration with Wengert and Lazax implementation
% Removes all poses based on reject images by intrinsic calibration
% cartCalibPoses: Cartesian calibration poses
% correctedPoeses: Corrected cartesian calibration poses
% imagesUsed: Mask (vector) with rejected and accepted images

function [ handEyeWengert, handEyeLazax ] = handEyeCalibrationTSAI( cartCalibPoses, correctedPoses, imagesUsed)
% Set counter
j = 1;
for i = 1:size(cartCalibPoses, 1)
    if imagesUsed(i)
        % Convert to hom matrix
        pose = cartCalibPoses(j,:); 
        
        X = pose(1);
        Y = pose(2);
        Z = pose(3);
        Roll = pose(4);
        Pitch = pose(5);
        Yaw = pose(6);
         
        rotationMatrix = rpyToRotationMatrix(Roll, Pitch, Yaw);
        tform = rotm2tform(rotationMatrix);
        tform(1,4) = X;
        tform(2,4) = Y;
        tform(3,4) = Z;
        
        tcpPoseInBaseCoords(:,:,j) = tform;
        
        j = j + 1;
    end
    
end

% Set counter
j = 1;
for i = 1:size(imagesUsed)   
    if imagesUsed(i)
        % Convert to hom matrix
        gridPoseInCameraCoordsCorrected(:,:,j) = rotm2tform(inv(correctedPoses.correctedOrientationMatrix(:,:,j)));
             
        gridPoseInCameraCoordsCorrected(1,4,j) = correctedPoses.correctedTranslationVector(:,1,j);
        gridPoseInCameraCoordsCorrected(2,4,j) = correctedPoses.correctedTranslationVector(:,2,j);
        gridPoseInCameraCoordsCorrected(3,4,j) = correctedPoses.correctedTranslationVector(:,3,j);
        cameraPoseInGridCoordsCorrected(:,:,j) = inv(gridPoseInCameraCoordsCorrected(:,:,j));
        
        j = j + 1;
    end
end

% Compute hand eye calibration
handEyeWengert = TSAIleastSquareCalibration(tcpPoseInBaseCoords, gridPoseInCameraCoordsCorrected);
handEyeLazax = HandEye(tcpPoseInBaseCoords, cameraPoseInGridCoordsCorrected);

end

