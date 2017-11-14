#!/bin/bash

#cgexec -g memory:salt/streamer --sticky python pygst-kinect/pipe.py

#cgexec -g memory:salt/streamer --sticky gst-launch-1.0 v4l2src ! 'video/x-raw, format=(string){UYVY}, width=640, height=480, framerate=10/1' ! videoconvert ! omxh264enc target-bitrate=150000 control-rate=variable ! rtph264pay config-interval=1 pt=96 ! udpsink host=160.85.37.142 port=30971 sync=false

cgexec -g memory:salt/streamer --sticky gst-launch-1.0 v4l2src device=/dev/video1 ! 'video/h264, width=640, height=480, framerate=15/1' ! h264parse ! rtph264pay config-interval=1 pt=96 ! udpsink host=160.85.37.142 port=30971 sync=false
