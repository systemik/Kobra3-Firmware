# Kobra3-Firmware
Kobra3 Firmware information and How to update Kobra3 Firmware via USB

> [!WARNING]
> # USE AT YOUR OWN RISK. I TAKE NO RESPONSABILITY OF WHAT YOU DO WITH BELOW INFORMATION

**In short:**

You need to create a file called "**update.sh**"
You can put whatever you want (at your onwn risk) in the script file.

For SSH access, you need to copy back the openssh lib which has been deleted with recent firmware and then start openssh server. 
Server binary needs to be modified to use /tmp/empty instead of /var/empty (/var/empty is read only and cannot be modified - squashfs filesystem).
I've created an updated version of the openssh lib so it can be launched from the useremain directory and not be deleted with next firmware update. 
The new ssh server run on **port 2222**

You then need to **tar/gzip** these files. The resulting file must be called "**setup.tar.gz**".

This file should then be put in a folder name "**update_swu**".

You should then **zip** the update_swu folder and set the zip password to **U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w=** (use zipcypto format. Not sure AES encryption will work).

The resulting file must be named **update.swu**


Once done, you should go to your usb stick and create a folder called "**update**" and put the **update.swu** file in it. (if you use the command at the bottom of readme, the foler and files are automatically created).

Plug the stick, boot the printer. Follow the steps on printer touch screen (on the readme below). It should do few bips and the update should done. It may take a bit of time the first time as it needs to create ssh keys on the printer.

You will need to reboot the printer when done.

Test if you can connect via SSH again. (**port 2222**)


---
**Summary of the steps :**

1) Create update.sh
2) tar the file to setup.tar
3) gzip the file to setup.tar.gz
4) create a folder called update_swu
5) move the file setup.tar.gz in the folder update_swu
6) zip the folder update_swu with password U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w=
7) rename the zip file to update.swu
8) create a folder on the usb stick called update
9) put the file update.swu in update
10) boot printer with the stick, check for update in the printer information menu
11) do the update
12) reboot the printer
13) test ssh access port 2222 (or adb)


**Windows command lines to create the proper structure for the usb stick :**

    tar -cvzf setup.tar.gz update.sh openssh
    mkdir update_swu
    move setup.tar.gz update_swu
    zip -P U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w= -r update.swu update_swu
    mkdir update
    move update.swu update


**Steps for the update (touch screen) :**

![step1](/screenshots/attachment.jpg "step1").
  
![step2](/screenshots/attachment(1).jpg "step2").
  
![step3](/screenshots/attachment(2).jpg "step3").
  
![step4](/screenshots/attachment(3).jpg "step4").
  
![step5](/screenshots/attachment(4).jpg "step5").
  
![step6](/screenshots/attachment(5).jpg "step6").
