% Stop simulatin 
% Disconnect
% simCon: Struct with simulation vars

function [] = stopSimulation( simCon )
simCon.vrep.simxStopSimulation(simCon.clientID, simCon.vrep.simx_opmode_oneshot);
%close connection
simCon.vrep.simxGetPingTime(simCon.clientID); %make sure the last command could be sent
simCon.vrep.simxFinish(simCon.clientID);
end

