#!/bin/bash
PIDS=$(cat /sys/fs/cgroup/memory/salt/streamer/cgroup.procs)
for pid in $PIDS; do
    [ -d /proc/$pid ] && kill $pid
done
sleep 1
# Make second loop and hard kill any remaining
for pid in $PIDS; do
    [ -d /proc/$pid ] && kill -KILL $pid
done

