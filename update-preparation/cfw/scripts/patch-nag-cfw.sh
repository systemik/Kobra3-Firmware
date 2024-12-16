#!/bin/sh
# Specify the file and expected MD5 checksum
file="/userdata/app/gk/K3SysUi"
expected_md5="e4546ff669ad8f5b22b74d613cc6c410"

# Compute the file's MD5 checksum
current_md5=$(md5sum "$file" | awk '{ print $1 }')

# Compare the checksum and run the script if it matches
if [ "$current_md5" == "$expected_md5" ]; then
    echo "MD5 checksum matches. Patching the file..."
    # change few bytes
    cp /userdata/app/gk/K3SysUi /userdata/app/gk/K3SysUi.bak
    ./patch-nag.sh &> /tmp/patch.log &
    echo "file patched" >> /tmp/patch.log
else
    echo "MD5 checksum does not match. Aborting."
fi
