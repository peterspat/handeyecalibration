% Initialize simulation handles
% simCon: Struct with simulation vars

function [err, simCon] = initialiseSimHandles(simCon)

% Error handling?
[errVisionHandle, simCon.visionHandle] = simCon.vrep.simxGetObjectHandle(simCon.clientID, 'Vision_sensor#', simCon.vrep.simx_opmode_blocking);
[errBaseHandle, simCon.baseHandle] = simCon.vrep.simxGetObjectHandle(simCon.clientID, 'base_dummy#', simCon.vrep.simx_opmode_blocking);
[errTcpHandle, simCon.tcpHandle] = simCon.vrep.simxGetObjectHandle(simCon.clientID, 'tcp_dummy#', simCon.vrep.simx_opmode_blocking);
[errGridHandle, simCon.gridHandle] = simCon.vrep.simxGetObjectHandle(simCon.clientID, 'grid_dummy#', simCon.vrep.simx_opmode_blocking);
[errCameraHandle, simCon.cameraHandle] = simCon.vrep.simxGetObjectHandle(simCon.clientID, 'camera_dummy#', simCon.vrep.simx_opmode_blocking);

% call these actions cause they trhow an error at first call
simCon.vrep.simxGetObjectPosition(simCon.clientID, simCon.tcpHandle, simCon.baseHandle, simCon.vrep.simx_opmode_streaming);
simCon.vrep.simxGetObjectOrientation(simCon.clientID, simCon.tcpHandle, -1, simCon.vrep.simx_opmode_streaming);
simCon.vrep.simxGetObjectOrientation(simCon.clientID, simCon.cameraHandle, simCon.gridHandle, simCon.vrep.simx_opmode_streaming);
simCon.vrep.simxGetObjectPosition(simCon.clientID, simCon.cameraHandle, simCon.gridHandle, simCon.vrep.simx_opmode_streaming);
simCon.vrep.simxGetVisionSensorImage2(simCon.clientID, simCon.visionHandle, 0, simCon.vrep.simx_opmode_streaming);

err = ~(errBaseHandle &&errVisionHandle && errTcpHandle && errGridHandle && errCameraHandle);

end