#!/bin/bash
source /opt/ros/indigo/setup.bash
source /home/turtlebot/catkin_ws/devel/setup.bash
exec /home/turtlebot/processmanagement/procman start roslaunch icclab_turtlebot minimal_with_rplidar_amcl.launch map_file:=/home/turtlebot/catkin_ws/src/icclab_turtlebot/icclab_latest_map.yaml initial_pose_x:=-5.97576435259 initial_pose_y:=2.07389271192 initial_pose_a:=3.14
