#!/bin/bash
source /opt/ros/indigo/setup.bash
source /home/turtlebot/catkin_ws/devel/setup.bash
cgexec -g memory:salt/docking roslaunch kobuki_auto_docking activate.launch
