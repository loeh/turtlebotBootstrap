#!/bin/bash
source /opt/ros/indigo/setup.bash
source /home/turtlebot/catkin_ws/devel/setup.bash
# creating cgroup
cgcreate -a root -t turtlebot -g memory:salt/docking
# executing docking
cgexec -g memory:salt/docking roslaunch kobuki_auto_docking compact.launch
