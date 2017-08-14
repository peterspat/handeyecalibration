% Start simulation
% simCon: Struct with simulation vars

function [] = startSimulation( simCon )
ret = simCon.vrep.simxStartSimulation(simCon.clientID, simCon.vrep.simx_opmode_oneshot);
end

