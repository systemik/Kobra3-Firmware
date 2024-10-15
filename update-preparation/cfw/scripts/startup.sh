#!/bin/sh

# Sleep a bit
sleep 20

#kill previously started apps
killall nginx
killall python3.11

# add library folder
export LD_LIBRARY_PATH=/useremain/dist/lib:/useremain/cfw/libs:$LD_LIBRARY_PATH
# add binary folder
export PATH=/useremain/cfw/binaries:$PATH

# make dir for sshd
mkdir /tmp/empty
# start sshd
/useremain/cfw/openssh/sshd_start.sh

# create some symbolic link to some interesting files
ln -s /userdata/app/gk/printer_mutable.cfg /useremain/cfw/nginx/printer_mutable.cfg
ln -s /userdata/app/gk/printer.cfg /useremain/cfw/nginx/printer.cfg
ln -s /userdata/app/gk/config/device_account.json /useremain/cfw/nginx/device_account.cfg

# make dir for nginx
mkdir /var/cache/nginx
# start nginx
/useremain/cfw/nginx/nginx -e /useremain/cfw/nginx/error.log -c /useremain/cfw/nginx/nginx.conf
# start flask server
/useremain/cfw/binaries/python3.11 /useremain/cfw/scripts/flask-server.py


# copy logs for debug
cp /tmp/gkui.log /mnt/udisk/
cp /userdata/app/gk/start.sh /mnt/udisk/

