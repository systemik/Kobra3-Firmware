# log script
set -x

# few bips

echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 1
echo 0 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 1
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 1
echo 0 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 1
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 1
echo 0 > /sys/class/pwm/pwmchip0/pwm0/enable

#####################################
########## OPENSSH AND ADB ##########
#####################################

# clean old openssh
rm -rf /useremain/update_swu/openssh
# copy new openssh (with /var/empty changed to /tmp/empty in the binary)
cp -r /useremain/update_swu/openssh /useremain/openssh

# change perms to allow script and binary execution
chmod +x /useremain/openssh/sshd_start.sh
chmod +x /useremain/openssh/sbin/sshd
chmod +x /useremain/openssh/bin/ssh-keygen
chmod +x /useremain/openssh/libexec/sftp-server

# add few commands (if not existing) to the end of the start script

# add sleep to allow network to be up and running
grep -qxF 'sleep 20' /userdata/app/gk/start.sh || echo 'sleep 20' >> /userdata/app/gk/start.sh
# create /tmp/empty (required for sshd to start)
grep -qxF 'mkdir /tmp/empty' /userdata/app/gk/start.sh || echo 'mkdir /tmp/empty' >> /userdata/app/gk/start.sh
# start custom sshd service
grep -qxF '/useremain/openssh/sshd_start.sh' /userdata/app/gk/start.sh || echo '/useremain/openssh/sshd_start.sh' >> /userdata/app/gk/start.sh
# send logs to ntfy server on local lan for debugging
grep -qxF 'curl --data-binary "@/tmp/gkui.log" 192.168.1.245/printer' /userdata/app/gk/start.sh || echo 'curl --data-binary "@/tmp/gkui.log" 192.168.1.245/printer' >> /userdata/app/gk/start.sh
# send start script content to ntfy server on local lan for debugging
grep -qxF 'curl --data-binary "@/userdata/app/gk/start.sh" 192.168.1.245/printer' /userdata/app/gk/start.sh || echo 'curl --data-binary "@/userdata/app/gk/start.sh" 192.168.1.245/printer' >> /userdata/app/gk/start.sh

# tweak adbd kill by changing adbd to adbc :-)
sed -i 's/adbd/adbc/g' /userdata/app/gk/start.sh

#####################################
########## NGINX WEBSERVER ##########
#####################################

# copy new nginx 
cp -r /useremain/update_swu/nginx /useremain/nginx

# change perms to allow script and binary execution
chmod +x /useremain/nginx/nginx


# copy libraries to the right place for nginx to work
cp /useremain/nginx/lib* /ac_lib/lib/third_lib/

# create some symbolic link to some interesting files
ln -s /userdata/app/gk/printer_mutable.cfg /useremain/nginx/printer_mutable.cfg
ln -s /userdata/app/gk/printer.cfg /useremain/nginx/printer.cfg
ln -s /userdata/app/gk/config/device_account.json /useremain/nginx/device_account.cfg

# create required directory for nginx
grep -qxF 'mkdir /var/cache/nginx' /userdata/app/gk/start.sh || echo 'mkdir /var/cache/nginx' >> /userdata/app/gk/start.sh

# start custom nginx service
grep -qxF '/useremain/nginx/nginx -e /useremain/nginx/error.log -c /useremain/nginx/nginx.conf' /userdata/app/gk/start.sh || echo '/useremain/nginx/nginx -e /useremain/nginx/error.log -c /useremain/nginx/nginx.conf' >> /userdata/app/gk/start.sh

# some more bips
sleep 5
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 1
echo 0 > /sys/class/pwm/pwmchip0/pwm0/enable
# send update logs to ntfy server on local lan for debugging
curl --data-binary "@/tmp/gkui.log" 192.168.1.245/printer
# send update logs to usb drive for debugging
cp /tmp/gkui.log /mnt/udisk/
# some more bips
sleep 1
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 2
echo 0 > /sys/class/pwm/pwmchip0/pwm0/enable