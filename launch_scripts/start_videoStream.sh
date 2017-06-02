#!/bin/bash
cgexec -g memory:salt/streamer --sticky python pygst-kinect/pipe.py
