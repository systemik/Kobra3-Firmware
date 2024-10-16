#!/bin/sh

TIMESTAMP=$(date +%s)

ffmpeg -i /mnt/udisk/delayphoto/delay.mp4 -vcodec libx264 -acodec aac -strict -2 /mnt/udisk/delayphoto/timelapse-$TIMESTAMP.mp4

