% Get current TCP pose from simulation
% simCon: Struct with simulation vars

function [res, tcpPose] = getSimTcpPose(simCon)

[errTcp, positionTcp] = simCon.vrep.simxGetObjectPosition(simCon.clientID, simCon.tcpHandle, simCon.baseHandle,...
    simCon.vrep.simx_opmode_streaming);

[errTcpOrient, orientationTcp] = simCon.vrep.simxGetObjectOrientation(simCon.clientID, simCon.tcpHandle,...
    -1, simCon.vrep.simx_opmode_streaming);

res = ~(errTcp && errTcpOrient);

if res
    tcpPose = convertSimData(orientationTcp, positionTcp);
end
end