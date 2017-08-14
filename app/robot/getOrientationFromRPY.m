% Compute orientation for ROS quaternion from RPY in degrees
% rollDegrees: Roll in deg
% pitchDegrees: Pitch in deg
% yawDegrees: Yaw in deg

function orientation = getOrientationFromRPY(rollDegrees, pitchDegrees, yawDegrees)

quat = angle2quat(deg2rad(yawDegrees),deg2rad(pitchDegrees),deg2rad(rollDegrees));

orientation=rosmessage('geometry_msgs/Quaternion');
orientation.X=quat(2);
orientation.Y=quat(3);
orientation.Z=quat(4);
orientation.W=quat(1);

end