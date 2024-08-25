echo "usb_adb_en" > /tmp/.usb_config
cp -r /useremain/update_swu/openssh /ac_lib/lib/openssh
cp -r /useremain/update_swu/openssh /useremain/openssh
chmod +x /ac_lib/lib/openssh/sshd_start.sh
chmod +x /useremain/update_swu/openssh/sshd_start.sh
/useremain/openssh/sshd_start.sh