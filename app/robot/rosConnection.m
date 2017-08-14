% Connect to ROS
% masterIp: IP of rosmaster
% localhosIp: Local IP
% nodeName: Name of connecting node

function [ rosCon ] = rosConnection(masterIp, localhosIp, nodeName)
%ROS simple MATLAB connection

% Start
rosshutdown;
rosinit(masterIp, 'NodeHost',localhosIp,'NodeName',nodeName);

% Init Subscribers / Publishers and store them
rosCon.subCartLWR1 = rossubscriber('/robots/lwr1/get_cartesian','geometry_msgs/Pose');
rosCon.pubCartLWR1 = rospublisher('/robots/lwr1/set_cartesian','geometry_msgs/Pose');

rosCon.subJointsLWR1 = rossubscriber('/robots/lwr1/get_joint','sensor_msgs/JointState');
rosCon.pubJointsLWR1 = rospublisher('/robots/lwr1/set_joint','sensor_msgs/JointState');

end

