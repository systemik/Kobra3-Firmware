#!/bin/sh

TIMESTAMP=$(date +%s)

ffmpeg -i delay.mp4 -vcodec libx264 -acodec aac -strict -2 timelapse-$TIMESTAMP.mp4