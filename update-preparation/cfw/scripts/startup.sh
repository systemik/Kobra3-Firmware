#!/bin/sh

# Sleep a bit
sleep 5

# kill previously started apps
killall nginx
killall python3.11
killall mjpg_streamer

# add library folder
export LD_LIBRARY_PATH=/useremain/cfw/libs:/useremain/cfw/libs/mjpg-streamer:$LD_LIBRARY_PATH

# add binary folder
export PATH=/useremain/cfw/binaries:$PATH

# add HOME folder
export HOME=/useremain/cfw


# change perms to allow script and binary execution
chmod +x /useremain/cfw/binaries/*
chmod +x /useremain/cfw/scripts/*
chmod +x /useremain/cfw/nginx/nginx

# Sync time
/useremain/cfw/binaries/ntpdate pool.ntp.org

#####################################
########## SSHD WEBSERVER #######3###
#####################################

# make # create required directory for sshd
mkdir /tmp/empty
# change perms to allow script and binary execution
chmod +x /useremain/cfw/openssh/sshd_start.sh
# start sshd
/useremain/cfw/openssh/sshd_start.sh

#####################################
########## NGINX WEBSERVER ##########
#####################################

# create some symbolic link to some interesting files
ln -s /userdata/app/gk/printer_mutable.cfg /useremain/cfw/nginx/html/printer_mutable.cfg
ln -s /userdata/app/gk/printer.cfg /useremain/cfw/nginx/html/printer.cfg
ln -s /userdata/app/gk/config/device_account.json /useremain/cfw/nginx/html/device_account.cfg
ln -s /mnt/udisk/Time-lapse-Video/ /useremain/cfw/nginx/html/timelapse
ln -s /useremain/app/gk/gcodes/ /useremain/cfw/nginx/html/upload

# create required directory for nginx
mkdir /var/cache/nginx

# start nginx
/useremain/cfw/nginx/nginx -e /useremain/cfw/nginx/error.log -c /useremain/cfw/nginx/nginx.conf
# start flask server
/useremain/cfw/binaries/python3.11 /useremain/cfw/scripts/flask-server.py &> /tmp/flask.log &

# clean previous symbolic links to configuration files
rm /useremain/cfw/nginx/html/printer_mutable.cfg
rm /useremain/cfw/nginx/html/printer.cfg
rm /useremain/cfw/nginx/html/device_account.cfg

# create some symbolic link to some interesting files
ln -s /userdata/app/gk/printer_mutable.cfg /useremain/cfw/nginx/printer_mutable.cfg
ln -s /userdata/app/gk/printer.cfg /useremain/cfw/nginx/printer.cfg
ln -s /userdata/app/gk/config/device_account.json /useremain/cfw/nginx/device_account.cfg


#####################################
########## CAMERA STREAM ############
#####################################

/useremain/cfw/binaries/mjpg_streamer -i "input_uvc.so -d /dev/video10 -f 10" &

#####################################
############ FEW THINGS #############
#####################################

# change device info to make mopsquitto work
/useremain/cfw/scripts/update-deviceinfo.sh

# copy logs for debug
cp /tmp/*.log /mnt/udisk/
cp /userdata/app/gk/start.sh /mnt/udisk/
