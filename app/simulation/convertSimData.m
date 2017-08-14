% Create a 4x4 hom matrix with converted orientaion for MATLAB
% Orientation has to be in ZYX
% simPosition: Simulated position of tcp
% simOrientation: Simulated orientation of tcp

function [ tcpPose ] = convertSimData(simPosition,  simOrientation)
rotationX = [ 1            0                        0;
    0 cos(simOrientation(1)) -sin(simOrientation(1));
    0 sin(simOrientation(1)) cos(simOrientation(1))];

rotationY = [ cos(simOrientation(2)) 0 sin(simOrientation(2))
    0            1                        0;
    -sin(simOrientation(2)) 0 cos(simOrientation(2))];

rotationZ = [ cos(simOrientation(3)) -sin(simOrientation(3)) 0;
    sin(simOrientation(3)) cos(simOrientation(3)) 0;
    0 0 1];


rotm = rotationX * rotationY * rotationZ;

tcpPose = rotm2tform(rotm);
tcpPose(1,4) = simPosition(1);
tcpPose(2,4) = simPosition(2);
tcpPose(3,4) = simPosition(3);

end

