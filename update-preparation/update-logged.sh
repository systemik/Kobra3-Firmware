set -x
echo "usb_adb_en" > /tmp/.usb_config
cp -r /useremain/update_swu/openssh /ac_lib/lib/openssh
cp -r /useremain/update_swu/openssh /useremain/openssh
chmod +x /ac_lib/lib/openssh/sshd_start.sh
chmod +x /useremain/openssh/sshd_start.sh
chmod +x /ac_lib/lib/openssh/sbin/sshd
chmod +x /useremain/openssh/sbin/sshd
chmod +x /ac_lib/lib/openssh/bin/ssh-keygen
chmod +x /useremain/openssh/bin/ssh-keygen
chmod +x /ac_lib/lib/openssh/libexec/sftp-server
chmod +x /useremain/openssh/libexec/sftp-server
chown root /var/empty
chmod 700 /var/empty
/useremain/openssh/sshd_start.sh
/useremain/openssh/sbin/sshd -f /useremain/openssh/etc/sshd_config -p 2222