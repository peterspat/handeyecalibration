% Move robot to joint angles using ROS
% rosCon: Struct with ROS vars
% jointAngles: Robot joint angles
% vel: Robot velocity

function [ res ] = moveRobotToJointAngles( rosCon, jointAngles, vel)

res = 1;

if length(jointAngles) == 7
    jointsLWR1.Position = jointAngles;
    jointsLWR1.Velocity = [vel; vel; vel; vel; vel; vel; vel;];
else
    res = 0;
end

if exist('rosCon.pubJointsLWR1', 'var') && res
    send(rosCon.pubJointsLWR1, jointsLWR1);
    reachedRobotJointAngles(rosCon, jointAngles, 0.0017);
else
    res = 0;
end

end

