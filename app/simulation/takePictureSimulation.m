% Capture a picture from simulated camera
% simCon: Struct with simulation vars
% imageNumber: Number to enumerate images
% filePath: Path to store images

function [res, imgPath, imgName] = takePictureSimulation(simCon, imageNumber, filePath )
    %Error?
    [err, ~, image] = simCon.vrep.simxGetVisionSensorImage2(simCon.clientID,...
                      simCon.visionHandle, 0, simCon.vrep.simx_opmode_streaming);
                  
    if (imageNumber < 10)
        path = [filePath '\capture_0' int2str(imageNumber) '.png'];
    else
        path = [filePath '\capture_' int2str(imageNumber) '.png'];
    end
    
    [imgPath, imgName, ext] = fileparts(path);
    imgName = [imgName ext];
    imgPath = [imgPath '\' imgName];
    
    if ~err && ~isempty(image)
        imwrite(image, path);
        res = 1;
    else
        res = 1;
    end
    
    imgName = cellstr(imgName);
    imgPath = cellstr(imgPath);
    
end