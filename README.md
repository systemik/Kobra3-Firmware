# Kobra3-Firmware
Kobra3 Firmware information and How to update Kobra3 Firmware via USB

> [!WARNING]
> # USE AT YOUR OWN RISK: I TAKE NO RESPONSABILITY OF WHAT YOU DO WITH BELOW INFORMATION

**In short:**

You need to create a file called "**update.sh**"
You can put whatever you want (at your onwn risk) in the script file.

~~To enable back **ADB**, you can put this in the file :~~

~~echo "usb_adb_en" > /tmp/.usb_config~~

~~This is a config file that is used when the printer start. The init script located in /etc/init.d/S50usbdevice will read this and then enable the adb deamon at start.~~

ADB is not really required and it is preferable to activate back openssh.
For this, you need to copy back the openssh lib which has been deleted with recent firmware and then start openssh server. 
I've create an updated version of the openssh lib so it can run in the useremain directory and not be deleted with next firmware update.

You then need to **tar/gzip** this file. The resulting file must be called "**setup.tar.gz**".

This file should then be put in a folder name "**update_swu**".

You should then **zip** the update_swu folder and set the zip password to **U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w=** (use zipcypto format. Not sure AES encryption will work).

The resulting file must be named **update.swu**



Once done, you should go to your usb stick and create a folder called "**udisk_upgradation**" and put the **update.swu** file in it.

Plug the stick, boot the printer. It should do a single bip and the update should be ok.

Test if you can connect via SSH again.

If you prefer, you can try to start adb again with this in the **update.sh** file (not tested):


    mkdir /dev/usb-ffs/adb -m 0770
    mount -o uid=2000,gid=2000 -t functionfs adb /dev/usb-ffs/adb
    start-stop-daemon --start --quiet --background --exec /usr/bin/adbd


---
**Summary of the steps :**

1) Create update.sh
2) tar the file to setup.tar
3) gzip the file to setup.tar.gz
4) create a folder called update_swu
5) move the file setup.tar.gz in the folder update_swu
6) zip the folder update_swu with password U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w=
7) rename the zip file to update.swu
8) create a folder on the usb stick called udisk_upgradation
9) put the file update.swu in udisk_upgradation
10) boot printer with the stick, or insert the stick after printer is booted (if update works, you should hear a long bip)
11) reboot the printer
12) test ADB access
