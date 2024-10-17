# Kobra3-Firmware - ADB + SSH + BED MESH VISUALIZER(2.3.3.9) + LIGHT CONTROL + TIMELAPSE ACCESS/CONVERT
Kobra3 Firmware information and How to update Kobra3 Firmware via USB

> [!WARNING]
> # USE AT YOUR OWN RISK. I TAKE NO RESPONSABILITY OF WHAT YOU DO WITH BELOW INFORMATION
> # Latest version tested : 2.3.3.9

This version start adb + ssh on port 2222 and a web server on port 80.
Web server provide access to 4 pages :
- Bed leveling info
- Camera streaming + led control (Mp4 conversion may not work for now)
- Access to timelapse of the USB stick
- Upload page to upload gcode to the printer

**Copy** the folder in update-preparation called **aGVscF9zb3Nf** at the **root** of the **usb** stick.
**Boot** the printer.
**Wait** a minute and strong **bips** will be emitted.
**Wait** one more minute and after some more **bips**, the **tetris** song will play.
After **tetris** song, **reboot** the printer and that's it. You can **connect** to the **web page**.

**Main**
![Main](/screenshots/Main.png "Main").
**Bed**
![Bed](/screenshots/Bed.png "Bed").
**Camera**
![Camera](/screenshots/Camera.png "Camera").
**Upload**
![Upload](/screenshots/Upload.png "Upload").
**Timelapse**
![Timelapse](/screenshots/Timelapse.png "Timelapse").

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
9) put the file update.swu in aGVscF9zb3Nf
10) boot printer with the stick, depending on your current firmware version, either the printer will update and start bipping or you need to check for update in the printer information menu
11) do the update
12) reboot the printer
13) remove the aGVscF9zb3Nf folder from the usb stick
14) boot the printer again
15) test ssh access port 2222 (or adb) and connect to printer ip in http to see the web menu (http://x.x.x.x/)

---

**How to if you want to do it yourself:**

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


Once done, you should go to your usb stick and create a folder called "**aGVscF9zb3Nf**" and put the **update.swu** file in it. (if you use the command at the bottom of readme, the foler and files are automatically created).

Plug the stick, boot the printer. Either the update start itself and you'll hear plenty of beeps with a long one at the end or follow the steps on printer touch screen (on the readme below). It should do few bips and the update should done. It may take a bit of time the first time as it needs to create ssh keys on the printer.

You will need to reboot the printer when done. Go to your USB stick and rename or remove the folder **aGVscF9zb3Nf** to avoid the update to be performed everytime and messing with files.

Test if you can connect via SSH again. (**port 2222**)

---

> [!WARNING]
> In the folder "update-preparation" you will find the required files and in the "update.swu" you will find a prepackaged update. I invite you to open the update package and check the content before applying it to your printer (opeen swu with 7zip, decompress and use password mentionned above).

---

**Windows command lines to create the proper structure for the usb stick :**

    tar -cvzf setup.tar.gz update.sh openssh nginx
    mkdir update_swu
    move setup.tar.gz update_swu
    zip -P U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w= -r update.swu update_swu
    mkdir aGVscF9zb3Nf
    move update.swu aGVscF9zb3Nf


**If you connect to your printer newly installed webserver, you can view the main page :**

Address: http://x.x.x.x/


**BED:**

![visualizer](/screenshots/visualizer.png "visualizer").


**Steps for the update (touch screen) :**

![step1](/screenshots/attachment.jpg "step1").
  
![step2](/screenshots/attachment(1).jpg "step2").
  
![step3](/screenshots/attachment(2).jpg "step3").
  
![step4](/screenshots/attachment(3).jpg "step4").
  
![step5](/screenshots/attachment(4).jpg "step5").
  
![step6](/screenshots/attachment(5).jpg "step6").

![step7](/screenshots/attachment(6).jpg "step7").


