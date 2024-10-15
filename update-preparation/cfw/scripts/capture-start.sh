#!/bin/sh

USER=$(/useremain/cfw/binaries/jq -r '.username' /userdata/app/gk/config/device_account.json)
PASS=$(/useremain/cfw/binaries/jq -r '.password' /userdata/app/gk/config/device_account.json)
PRINTER=$(/useremain/cfw/binaries/jq -r '.deviceId' /userdata/app/gk/config/device_account.json)
# Current timestamp in seconds
TIMESTAMP=$(date +%s)

mosquitto_pub -h 192.168.1.233 -p 9883 -u "$USER" -P "$PASS" -t "anycubic/anycubicCloud/v1/web/printer/20024/$PRINTER/video" -m "{\"type\": \"video\", \"action\": \"startCapture\", \"timestamp\": $TIMESTAMP,\"msgid\": \"02fd3987-a2ff-244e-7c95-7fe257a9ef70\", \"data\": null}" -d --insecure --cafile /useremain/cfw/openssl/ca.crt
