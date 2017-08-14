% Capture a picture from a camera mounted on the robot
% shutterSpeed: Speed of shutter
% gain: Camera gain
% imagePath: Path to store image

function [imgPath, imgName] = takePictureRobot(shutterSpeed, gain, imagePath)
% shutterSpeed [ms], gain [db], metadata [struct]
metadata.sequence.saveDir = imagePath;
url = 'http://localhost/capture?shutter=';
url = [url num2str(shutterSpeed) '&gain=' num2str(gain)];
options = weboptions('MediaType','application/json');
ret = webwrite(url, metadata, options);
imgName = ret(strfind(ret,'capture_'):end);
imgPath = strcat(metadata.sequence.saveDir,'\',imgName ,'.png');
end