% Connect to simulation using API

function [simCon] = connectToSimulation()
simCon.vrep = remApi('remoteApi');
simCon.vrep.simxFinish(-1);
simCon.clientID = simCon.vrep.simxStart('127.0.0.1', 19997, true, true, 5000, 5);
end
