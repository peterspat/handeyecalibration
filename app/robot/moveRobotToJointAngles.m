% Move robot to joint angles using ROS
% rosCon: Struct with ROS vars
% jointAngles: Robot joint angles
% vel: Robot velocity

function [ res ] = moveRobotToJointAngles( rosCon, jointAngles, vel)

res = 1;

if length(jointAngles) == 7
    rosCon.jointsLWR1.Position = jointAngles;
    rosCon.jointsLWR1.Velocity = [vel; vel; vel; vel; vel; vel; vel;];
else
    res = 0;
end

if isfield(rosCon, 'pubJointsLWR1') && res
    send(rosCon.pubJointsLWR1, rosCon.jointsLWR1);
    reachedRobotJointAngles(rosCon, jointAngles, 0.0017);
else
    res = 0;
end

end

