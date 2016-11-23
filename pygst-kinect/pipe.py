#!/usr/bin/env python
""" Test pipelines """
# -*- Mode: Python -*-
# vi:si:et:sw=4:sts=4:ts=4
#

import gobject
gobject.threads_init()

import pygst
pygst.require('0.10')
import gst

import numpy
import cv
import freenect

import kinectcamsrc
import kinectdepthsrc

port="5000"

p1 = ('kinectcamsrc '
'! rtpvrawpay '
'! udpsink host=127.0.0.1 port=%s') % port

p2 = ('kinectcamsrc ' '! fakesink')


p3 = ('kinectcamsrc ' 
'! video/x-raw-rgb,width=640,height=480 '
'! ffmpegcolorspace '
'! xvimagesink')

p4 = ('kinectdepthsrc ' 
'! ffmpegcolorspace '
'! video/x-raw-gray,width=640,height=480,bpp=(int)16,depth=(int)16 '
'! ffmpegcolorspace '
'! xvimagesink')

p5 = ('kinectcamsrc '
'! ffmpegcolorspace '
'! video/x-raw-yuv,width=640,height=480,framerate=0/1 '
'! x264enc tune=zerolatency option-string="fps=10" pass=5 quantizer=22 speed-preset=1 profile=baseline '
#'! x264enc pass=5 quantizer=22 speed-preset=1 profile=baseline '
'! video/x-h264,width=640,height=480 '
'! rtph264pay config-interval=1 pt=96 '
#'! fakesink')
'! udpsink host=52.59.60.211 port=32458')


cam = gst.parse_launch(p5)
#depth = gst.parse_launch(p4)

cam.set_state(gst.STATE_PLAYING)
#depth.set_state(gst.STATE_PLAYING)

gobject.MainLoop().run()


