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

# clean previous install folder

rm -rf /mnt/udisk/aGVscF9zb3Nf-applied

#####################################
########## OPENSSH AND ADB ##########
#####################################

# clean old cfw
rm -rf /useremain/cfw
# copy new cfw
cp -r /useremain/update_swu/cfw /useremain/cfw

# change perms to allow script and binary execution
chmod +x /useremain/cfw/openssh/sshd_start.sh
chmod +x /useremain/cfw/openssh/sbin/sshd
chmod +x /useremain/cfw/openssh/bin/ssh-keygen
chmod +x /useremain/cfw/openssh/libexec/sftp-server
chmod +x /useremain/cfw/binaries/*
chmod +x /useremain/cfw/scripts/*

# add custom startup script
grep -qxF '/useremain/cfw/scripts/startup.sh &> /tmp/startup.log &' /userdata/app/gk/start.sh || echo '/useremain/cfw/scripts/startup.sh &> /tmp/startup.log &' >> /userdata/app/gk/start.sh

# tweak adbd kill by changing adbd to adbc :-)
sed -i 's/adbd/adbc/g' /userdata/app/gk/start.sh

#start startup script once 
/useremain/cfw/scripts/startup.sh &> /tmp/startup.log &

# some more bips
sleep 1
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
sleep 2
echo 0 > /sys/class/pwm/pwmchip0/pwm0/enable

# tetris success song
export LD_LIBRARY_PATH=/useremain/cfw/libs:/useremain/cfw/libs/mjpg-streamer:$LD_LIBRARY_PATH
/useremain/cfw/binaries/python3.11 /useremain/cfw/scripts/tetris.py

mv /mnt/udisk/aGVscF9zb3Nf /mnt/udisk/aGVscF9zb3Nf-applied