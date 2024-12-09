#!/bin/sh
export LD_LIBRARY_PATH=/useremain/cfw/libs:/useremain/cfw/libs/mjpg-streamer:$LD_LIBRARY_PATH
killall gkcam
/useremain/cfw/binaries/mjpg_streamer -i "input_uvc.so -d /dev/video10 -f 10" &
