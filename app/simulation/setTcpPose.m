% Set a TCP pose in simulation
% simCon: Struct with simulation vars
% tcpPose: TCP pose to simulate

function [res] = setTcpPose( simCon, tcpPose )
    errSetTcpOrientation = simCon.vrep.simxSetObjectOrientation(simCon.clientID, simCon.tcpHandle, simCon.baseHandle, deg2rad(tcpPose(4:6)), simCon.vrep.simx_opmode_oneshot);
    errSetTcpPos = simCon.vrep.simxSetObjectPosition(simCon.clientID, simCon.tcpHandle, simCon.baseHandle, tcpPose(1:3), simCon.vrep.simx_opmode_oneshot);
   
    res = 1;%errSetTcpPos && errSetTcpOrientation;
    %checking if sim arrived ????
    pause(1);
end

