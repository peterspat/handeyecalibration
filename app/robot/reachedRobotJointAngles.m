% Check if robot has reached target joint angels
% rosCon: Struct with ROS vars
% targetJointAngles: Joint angles to reach
% precision: Succes stopping condition (err <= precision)

function [ res ] = reachedRobotJointAngles( rosCon, targetJointAngles, precision )

res = 0;
robotPose = getRobotPose(rosCon);

if length(robotPose.jointsLWR1.Position) == length(targetJointAngles)
    while ~res
        robotPose = getRobotPose(rosCon);
        diff = abs(robotPose.jointsLWR1.Position - transpose(targetJointAngles)) <= precision;
        res = sum(diff) == length(targetJointAngles);
        pause(1);
    end
end

end

