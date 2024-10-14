#!/bin/sh

USER=$(/useremain/binaries/jq -r '.username' /userdata/app/gk/config/device_account.json)
PASS=$(/useremain/binaries/jq -r '.password' /userdata/app/gk/config/device_account.json)
PRINTER=$(/useremain/binaries/jq -r '.deviceId' /userdata/app/gk/config/device_account.json)
# Current timestamp in seconds
TIMESTAMP=$(date +%s)

#mosquitto_pub -h 192.168.1.233 -p 9883 -u $USER -P $PASS -t anycubic/anycubicCloud/v1/web/printer/20024/$PRINTER/video -m "{'type': 'video','action': 'startCapture','timestamp': 1660201929871,'msgid': '02fd3987-a2ff-244e-7c95-7fe257a9ef70','data': null}" -d --insecure --cafile /useremain/openssl/open3.crt
mosquitto_pub -h 192.168.1.233 -p 9883 -u "$USER" -P "$PASS" -t "anycubic/anycubicCloud/v1/web/printer/20024/$PRINTER/video" -m "{\"type\": \"video\", \"action\": \"startCapture\", \"timestamp\": $TIMESTAMP,\"msgid\": \"02fd3987-a2ff-244e-7c95-7fe257a9ef70\", \"data\": null}" -d --insecure --cafile /useremain/openssl/open3.crt
