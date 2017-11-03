% Check if robot has reached target joint angels
% rosCon: Struct with ROS vars
% targetJointAngles: Joint angles to reach
% precision: Succes stopping condition (err <= precision)

function [ res ] = reachedRobotJointAngles( rosCon, targetJointAngles, precision )

res = 0;
robotPose = getRobotPose(rosCon);

if length(robotPose.Joints) == length(targetJointAngles)
    while ~res
        robotPose = getRobotPose(rosCon);
        diff = abs(robotPose.Joints - transpose(targetJointAngles)) <= precision;
        res = sum(diff) == length(targetJointAngles);
        pause(1);
    end
end

end

