echo "usb_adb_en" > /tmp/.usb_config
cp -r /useremain/update_swu/openssh /ac_lib/lib/openssh
cp -r /useremain/update_swu/openssh /useremain/openssh
/useremain/openssh/sshd_start.sh