% Move the robot to a cart pose using ROS
% rosCon: Struct with ROS vars
% pose: Cartesian poose

function [res] = moveRobotToCartPose( rosCon, pose )

res = 1;

cartLWR1.Position.X = pose(1);
cartLWR1.Position.Y = pose(2);
cartLWR1.Position.Z = pose(3);
cartLWR1.Orientation = getOrientationFromRPY(pose(4), pose(5), pose(6));

if exist('rosCon.pubCartLWR1', 'var')
    send(rosCon.pubCartLWR1,cartLWR1);
else
    res = 0;
end

end

