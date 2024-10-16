#!/bin/sh

# Sleep a bit
sleep 10

#kill previously started apps
killall nginx
killall python3.11

# add library folder
export LD_LIBRARY_PATH=/useremain/dist/lib:/useremain/cfw/libs:$LD_LIBRARY_PATH
# add binary folder
export PATH=/useremain/cfw/binaries:$PATH

#####################################
########## SSHD WEBSERVER #######3###
#####################################

# make # create required directory for sshd
mkdir /tmp/empty
# start sshd
/useremain/cfw/openssh/sshd_start.sh

#####################################
########## NGINX WEBSERVER ##########
#####################################

# create some symbolic link to some interesting files
ln -s /userdata/app/gk/printer_mutable.cfg /useremain/cfw/nginx/printer_mutable.cfg
ln -s /userdata/app/gk/printer.cfg /useremain/cfw/nginx/printer.cfg
ln -s /userdata/app/gk/config/device_account.json /useremain/cfw/nginx/device_account.cfg

# create required directory for nginx
mkdir /var/cache/nginx
# change perms to allow script and binary execution
chmod +x /useremain/nginx/nginx
# start nginx
/useremain/cfw/nginx/nginx -e /useremain/cfw/nginx/error.log -c /useremain/cfw/nginx/nginx.conf
# start flask server
/useremain/cfw/binaries/python3.11 /useremain/cfw/scripts/flask-server.py &> /tmp/flask.log &

# clean previous symbolic links to configuration files
rm /useremain/cfw/nginx/printer_mutable.cfg
rm /useremain/cfw/nginx/printer.cfg
rm /useremain/cfw/nginx/device_account.cfg

# create some symbolic link to some interesting files
ln -s /userdata/app/gk/printer_mutable.cfg /useremain/cfw/nginx/printer_mutable.cfg
ln -s /userdata/app/gk/printer.cfg /useremain/cfw/nginx/printer.cfg
ln -s /userdata/app/gk/config/device_account.json /useremain/cfw/nginx/device_account.cfg

#####################################
########## NGINX WEBSERVER ##########
#####################################

# copy logs for debug
cp /tmp/*.log /mnt/udisk/
cp /userdata/app/gk/start.sh /mnt/udisk/

