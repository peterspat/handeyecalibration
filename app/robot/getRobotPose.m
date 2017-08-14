% Get current robot pose from ROS 
% Store joint angles and cart pose

function [ robotPose ] = getRobotPose( rosCon )

cartLWR1 = receive(rosCon.subCartLWR1);
jointsLWR1 = receive(rosCon.subJointsLWR1);

[roll, pitch, yaw] = getRPYFromROSPose(cartLWR1);

% Store cart pose as a vector
robotPose.Cart = [cartLWR1.Position.X, cartLWR1.Position.Y, cartLWR1.Position.Z,...
                       roll, pitch, yaw];
robotPose.Joints = jointsLWR1.Position;

end

