echo "usb_adb_en" > /tmp/.usb_config
cp -r /useremain/update_swu/openssh /ac_lib/lib/openssh
cp -r /useremain/update_swu/openssh /useremain/openssh
chmod +x /ac_lib/lib/openssh/sshd_start.sh
chmod +x /useremain//openssh/sshd_start.sh
chmod +x /ac_lib/lib/openssh/bin/*
chmod +x /ac_lib/lib/openssh/sbin/*
chmod +x /useremain/openssh/bin/*
chmod +x /useremain/openssh/sbin/*
/useremain/openssh/sshd_start.sh