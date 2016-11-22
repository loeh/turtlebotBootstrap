#!/bin/bash
source /opt/ros/indigo/setup.bash
source /home/turtlebot/catkin_ws/devel/setup.bash
exec /home/turtlebot/processmanagement/procman start roslaunch kobuki_auto_docking compact.launch
