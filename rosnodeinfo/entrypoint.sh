#!/bin/bash

# clone rospackage into catkin workspace

git clone $GIT_REPO /home/root/catkin_ws/src/rosnodeinfo

source /opt/ros/indigo/setup.bash
cd /home/root/catkin_ws/ && catkin_make
cd /home/root/catkin_ws/ && catkin_make install

source /home/root/catkin_ws/devel/setup.bash

# Start service
exec rosrun rosnodeinfo nodes.py