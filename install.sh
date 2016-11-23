#!/bin/bash

# install required packages as root
echo 'install required packages'
sudo bash << EOF
apt-get update
apt-get install -y tar git curl nano wget dialog net-tools build-essential python2.7 python-pip numpy freenect gstreamer-0.10 gstreamer0.10-plugins-base gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly gstreamer0.10-plugins-good cgroup-bin cgroup-lite libcgroup1
EOF

# create catkin_workspace
echo 'create catkin_workspace'
source /opt/ros/indigo/setup.bash
mkdir -p /home/turtlebot/catkin_ws/src
cd /home/turtlebot/catkin_ws/src && catkin_init_workspace

# copy ros packages to workspace
echo 'copy ros packages to workspace'
cp -r ./icclab_turtlebot /home/turtlebot/catkin_ws/src/icclab_turtlebot

cp -r ./moveto /home/turtlebot/catkin_ws/src/moveto

cp -r ./rosnodeinfo /home/turtlebot/catkin_ws/src/rosnodeinfo

git clone https://github.com/negre/rplidar_ros.git /home/turtlebot/catkin_ws/src/rplidar_ros

git clone https://furbaz:<pass>@bitbucket.org/rapyutians/cloud_bridge.git /home/turtlebot/catkin_ws/src/cloud_bridge

cd /home/turtlebot/catkin_ws && catkin_make

# copy launch scripts
echo 'copy ros packages to workspace'
cp ./launch_scripts/*.sh /home/turtlebot/

# copy rplidar daemon script
sudo bash << EOF
cp ./udev/rplidar /etc/init.d
EOF

# copy rplidar local rules
sudo bash << EOF
cp ./udev/10-local.rules /etc/udev/rules.d
EOF

# copy rplidar startup script
sudo bash << EOF
mkdir /etc/udev/scripts
cp ./udev/rplidar.sh /etc/udev/scripts
EOF

## cgroup stuff
cp ./cgroups/cgconfig.conf /etc
cp ./cgroups/cgrules.conf /etc

cp ./cgroups/cgrulesengd /etc/init

sudo bash << EOF
service cgroup-lite start 
EOF

