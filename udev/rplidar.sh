#!/bin/bash
source /opt/ros/indigo/setup.bash
source /home/turtlebot/catkin_ws/devel/setup.bash
mkdir /var/run/rplidar
chown turtlebot:turtlebot /var/run/rplidar
exec roslaunch icclab_turtlebot rplidar.launch
