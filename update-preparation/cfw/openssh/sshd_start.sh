#!/bin/sh

key_file_path=/useremain/cfw/openssh/etc

if [ ! -f "$key_file_path/ssh_host_rsa_key" ]
then
    echo "ssh_host_rsa_key file no exit, creating..."
    /useremain/cfw/openssh/bin/ssh-keygen -t rsa -f $key_file_path/ssh_host_rsa_key -N ""
fi

if [ ! -f "$key_file_path/ssh_host_ecdsa_key" ]
then
    echo "ssh_host_ecdsa_key file no exit, creating..."
    /useremain/cfw/openssh/bin/ssh-keygen -t rsa -f $key_file_path/ssh_host_ecdsa_key -N ""
fi

if [ ! -f "$key_file_path/ssh_host_ed25519_key" ]
then
    echo "ssh_host_ed25519_key file no exit, creating..."
    /useremain/cfw/openssh/bin/ssh-keygen -t rsa -f $key_file_path/ssh_host_ed25519_key -N ""
fi

is_cfg=$(cat $key_file_path/sshd_config | grep "HostKey /useremain/cfw/openssh/etc/ssh_host_rsa_key")

if [ "x$is_cfg" == "x" ]
then
    echo "no config, configing"
    sed -i '/#Port 22/aPort 2222' $key_file_path/sshd_config
    sed -i '/#PermitRootLogin prohibit-password/aPermitRootLogin yes' $key_file_path/sshd_config
    sed -i '/ssh_host_ed25519_key/aHostKey /useremain/cfw/openssh/etc/ssh_host_rsa_key\nHostKey /useremain/cfw/openssh/etc/ssh_host_ecdsa_key\nHostKey /useremain/cfw/openssh/etc/ssh_host_ed25519_key' $key_file_path/sshd_config
    sed -i '/^Subsystem/{s/^/#/}' $key_file_path/sshd_config
    sed -i '/#Subsystem/aSubsystem      sftp    /useremain/cfw/openssh/libexec/sftp-server' $key_file_path/sshd_config
else
    echo "config"
fi

sync

# chown -R root:root /var/empty
# chmod 755 /var/empty

/useremain/openssh/sbin/sshd -f /useremain/openssh/etc/sshd_config -p 2222

