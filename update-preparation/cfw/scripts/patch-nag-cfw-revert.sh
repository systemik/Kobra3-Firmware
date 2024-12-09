#!/bin/sh
# Specify the file and expected MD5 checksum
file="/userdata/app/gk/K3SysUi.bak"
expected_md5="e4546ff669ad8f5b22b74d613cc6c410"

# Compute the file's MD5 checksum
current_md5=$(md5sum "$file" | awk '{ print $1 }')

# Compare the checksum and run the script if it matches
if [ "$current_md5" == "$expected_md5" ]; then
    echo "MD5 checksum matches. Restore the file..."
    # change few bytes
    cp /userdata/app/gk/K3SysUi.bak /userdata/app/gk/K3SysUi
    echo "file reverted" >> /tmp/patch.log
else
    echo "MD5 checksum does not match. Aborting."
fi
