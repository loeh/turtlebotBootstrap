#!/bin/bash

# store base path of execution
BASEDIR=$(pwd)
USER='turtlebot'

# install sources for salt-minion
sudo bash << EOF
wget -O - https://repo.saltstack.com/apt/debian/8/armhf/2016.11/SALTSTACK-GPG-KEY.pub | apt-key add -
echo 'deb http://repo.saltstack.com/apt/debian/8/armhf/2016.11 jessie main' > /etc/apt/sources.list.d/saltstack.list
EOF

# installing required packages
echo 'installing required packages'
echo '-----------------------'
sudo bash << EOF
apt-get update
apt-get install -y tar git curl nano wget dialog net-tools build-essential python2.7 python-pip freenect gstreamer-0.10 gstreamer0.10-plugins-base gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly gstreamer0.10-plugins-good cgroup-bin cgroup-lite libcgroup1 daemon salt-minion ros-kinetic-kobuki ros-kinetic-kobuki-core python-gst0.10 doxygen graphviz mono-complete build-essential libusb-1.0-0-dev freeglut3-dev openjdk-7-jdk
pip install numpy
EOF

# install docker
echo 'installing docker'
echo '-----------------------'
sudo bash << EOF
apt-get install apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
echo "deb [arch=armhf] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install docker-ce
EOF


# create udev rule for kobuki
echo 'create udev rule for kobuki'
echo '-----------------------'
source /opt/ros/kinetic/setup.bash
rosrun kobuki_ftdi create_udev_rules

# create catkin_workspace
echo 'create catkin_workspace'
echo '-----------------------'
if [ ! -d /home/$USER/catkin_ws ] ; then
  source /opt/ros/kinetic/setup.bash
  mkdir -p /home/$USER/catkin_ws/src
  cd /home/$USER/catkin_ws/src && catkin_init_workspace
else
  echo 'workspace already exists'
  echo '-----------------------'
fi

# copy ros packages to workspace
echo 'copy ros packages to workspace'
echo '-----------------------'

cd $BASEDIR

if [ ! -d /home/$USER/catkin_ws/src/icclab_turtlebot ] ; then
  git clone https://github.com/icclab/icclab_turtlebot.git -b kinetic  /home/$USER/catkin_ws/src/icclab_turtlebot
else
  echo 'icclab package already exists'
  echo '-----------------------'
fi

if [ ! -d /home/$USER/catkin_ws/src/moveto ] ; then
  cp -r moveto/ /home/$USER/catkin_ws/src/moveto
else
  echo 'moveto package already exists'
  echo '-----------------------'
fi

if [ ! -d /home/$USER/catkin_ws/src/rosnodeinfo ] ; then
  cp -r rosnodeinfo/ /home/$USER/catkin_ws/src/rosnodeinfo
else
  echo 'rosnodeinfo package already exists'
  echo '-----------------------'
fi

if [ ! -d /home/$USER/catkin_ws/src/rplidar_ros ] ; then
  git clone https://github.com/negre/rplidar_ros.git /home/$USER/catkin_ws/src/rplidar_ros
else
  echo 'rplidar_ros package already exists'
  echo '-----------------------'
fi

if [ ! -d /home/$USER/catkin_ws/src/cloud_bridge ] ; then
  git clone https://furbaz:%40bitbucket2long@bitbucket.org/rapyutians/cloud_bridge.git /home/$USER/catkin_ws/src/cloud_bridge
else
  echo 'cloud_bridge package already exists'
  echo '-----------------------'
fi

cd /home/$USER/catkin_ws && catkin_make
cd $BASEDIR

# get python wrappers for libfreenect
echo 'install python wrappers libfreenect'
echo '-----------------------'
git clone https://github.com/OpenKinect/libfreenect.git
sudo bash << EOF
cd /home/$USER/libfreenect/wrappers/python && python setup.py install
EOF
cd $BASEDIR

# install openni
echo 'install openni'
echo '-----------------------'
git clone https://github.com/OpenNI/OpenNI
sudo bash << EOF
cd /home/$USER/OpenNI/Platform/Linux/CreateRedist && ./RedistMaker
cd ../Redist/* && ./install.sh
EOF
cd $BASEDIR

# install SensorKinect
echo 'install SensorKinecet'
echo '-----------------------'
git git clone https://github.com/avin2/SensorKinect
sudo bash << EOF
cd /home/$USER/SensorKinect/Platform/Linux/CreateRedist && ./RedistMaker
cd ../Redist/* && ./install.sh
EOF
cd $BASEDIR

# salt minion config
echo 'copy salt minion config'
echo '-----------------------'
sudo bash << EOF
yes | cp -rf salt/minion /etc/salt
EOF

# copy launch scripts
echo 'copy ros packages to workspace'
echo '-----------------------'
cp launch_scripts/*.sh /home/$USER/


# copy pygst kinect
echo 'copy pygst kinect'
echo '-----------------------'
cp -r pygst-kinect/ /home/$USER

# copy rplidar daemon script
echo 'create daemon for rplidar'
echo '-----------------------'
sudo bash << EOF
cp udev/rplidar /etc/init.d
chmod +x /etc/init.d/rplidar
EOF

# copy DockDriveActionClient
echo 'copy DockDriveActionClient'
echo '-----------------------'
sudo bash << EOF
yes | cp -rf docking/DockDriveActionClient.py /opt/ros/kinetic/lib/kobuki_auto_docking
EOF

# copy rplidar local rules
echo 'copy udev rules'
echo '-----------------------'
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
echo 'copy cgroup conf'
echo '-----------------------'
sudo bash << EOF
cp cgroups/cgconfig.conf /etc
cp cgroups/cgrules.conf /etc
yes | cp -rf cgroups/cgroup-lite.conf /etc/init

cp cgroups/cgrulesengd.conf /etc/init
EOF

## rplidar conf
echo 'copy rplidar conf'
echo '-----------------------'
sudo bash << EOF
cp rplidar/rplidar.conf /etc/init
EOF

## rplidar user settings
echo 'add user to dialout group'
echo '-----------------------'
sudo bash << EOF
gpasswd --add $USER dialout
EOF

sudo bash << EOF
service cgroup-lite start 
EOF

echo 'Installation complete, please restart your system!'
echo '--------------------------------------------------'

