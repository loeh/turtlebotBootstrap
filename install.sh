#!/bin/bash

# store base path of execution
BASEDIR=$(pwd)


echo 'install required packages'
sudo bash << EOF
apt-get update
apt-get install -y tar git curl nano wget dialog net-tools build-essential python2.7 python-pip freenect gstreamer-0.10 gstreamer0.10-plugins-base gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly gstreamer0.10-plugins-good cgroup-bin cgroup-lite libcgroup1
pip install numpy
EOF

# create catkin_workspace
echo 'create catkin_workspace'
echo '-----------------------'
if [ ! -d /home/turtlebot/catkin_ws ] ; then
  source /opt/ros/indigo/setup.bash
  mkdir -p /home/turtlebot/catkin_ws/src
  cd /home/turtlebot/catkin_ws/src && catkin_init_workspace
else
  echo 'workspace already exists'
  echo '-----------------------'
fi

# copy ros packages to workspace
echo 'copy ros packages to workspace'

cd $BASEDIR

cp -r icclab_turtlebot/ /home/turtlebot/catkin_ws/src/icclab_turtlebot

cp -r moveto/ /home/turtlebot/catkin_ws/src/moveto

cp -r rosnodeinfo/ /home/turtlebot/catkin_ws/src/rosnodeinfo

git clone https://github.com/negre/rplidar_ros.git /home/turtlebot/catkin_ws/src/rplidar_ros

git clone https://furbaz:%40bitbucket2long@bitbucket.org/rapyutians/cloud_bridge.git /home/turtlebot/catkin_ws/src/cloud_bridge

cd /home/turtlebot/catkin_ws && catkin_make
cd $BASEDIR

# copy launch scripts
echo 'copy ros packages to workspace'
cp launch_scripts/*.sh /home/turtlebot/


# copy pygst kinect
echo 'copy pygst kinect'
echo '-----------------------'
cp pygst-kinect/ /home/turtlebot

# copy rplidar daemon script
sudo bash << EOF
cp udev/rplidar /etc/init.d
chmod +x /etc/init.d/rplidar
EOF

# copy rplidar local rules
sudo bash << EOF
cp udev/10-local.rules /etc/udev/rules.d
EOF

# copy rplidar startup script
sudo bash << EOF
mkdir /etc/udev/scripts
cp udev/rplidar.sh /etc/udev/scripts
chmod +x /etc/udev/scripts/rplidar.sh
EOF

## cgroup stuff
sudo bash << EOF
cp cgroups/cgconfig.conf /etc
cp cgroups/cgrules.conf /etc

cp cgroups/cgrulesengd.conf /etc/init
EOF

sudo bash << EOF
service cgroup-lite start 
EOF

echo 'Installation complete'
echo '-----------------------'


