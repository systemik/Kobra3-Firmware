#!/bin/sh

# Sleep a bit
sleep 20

#kill previously started apps
killall nginx
killall python3.11

# add library folder
export LD_LIBRARY_PATH=/useremain/dist/lib:/useremain/libs:$LD_LIBRARY_PATH
# add binary folder
export PATH=/useremain/binaries:$PATH

# make dir for sshd
mkdir /tmp/empty
# start sshd
/useremain/openssh/sshd_start.sh

# make dir for nginx
mkdir /var/cache/nginx
# start nginx
/useremain/nginx/nginx -e /useremain/nginx/error.log -c /useremain/nginx/nginx.conf
# start flask server
/useremain/dist/bin/python3.11 /useremain/flask-server.py


# copy logs for debug
cp /tmp/gkui.log /mnt/udisk/




mkdir /tmp/empty
/useremain/openssh/sshd_start.sh
curl --data-binary "@/tmp/gkui.log" 192.168.1.245/printer
curl --data-binary "@/userdata/app/gk/start.sh" 192.168.1.245/printer




