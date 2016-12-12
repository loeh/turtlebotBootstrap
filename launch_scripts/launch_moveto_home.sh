#!/bin/bash
source /opt/ros/indigo/setup.bash
source /home/turtlebot/catkin_ws/devel/setup.bash
exec rosrun moveto moveTo.py home
