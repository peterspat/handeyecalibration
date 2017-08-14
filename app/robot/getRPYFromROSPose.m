% Compute RPY from ROS pose
% pose: ROS pose

function [roll, pitch, yaw] = getRPYFromROSPose(pose)
[yaw, pitch, roll] = quat2angle([pose.Orientation.W pose.Orientation.X pose.Orientation.Y pose.Orientation.Z]);
roll = rad2deg(roll);
pitch = rad2deg(pitch);
yaw = rad2deg(yaw);
end