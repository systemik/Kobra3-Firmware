
You can connect to MQTT on port 9338

![mqtt](/mqtt/mqtt.png "mqtt").

There is a way (WIP) to run a mqtt bridge with websocket and interface a webpage with the printer.
Webpage with mqtt javascript library -> mosquitto bridge with websocket enabled -> mqtt printer broker
This allow to subscribe and publish to printer topics.


Here are few topic and what needs to be posted to them to execute an action:


# Change ACE Slot 3 (4th roll) filament type and color.

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/multiColorBox, qos: 0
```
{
      "type": "multiColorBox",
      "action": "setInfo",
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "timestamp": 1660201929871,
      "data": {
        "multi_color_box":[
          {
            "id": 0,
            "slots":[
              {
                "index": 3,
                "type": "PLA +",
                "color": [244,0,49]
              }
            ]
          }
        ]
      }
    }
```


# Start ACE drying at 45° for 4 hours

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/multiColorBox, qos: 0
```
{
      "type": "multiColorBox",
      "action": "setDry",
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "timestamp": 1660201929871,
      "data": {
        "multi_color_box":[
          {
            "id": 0,
            "drying_status": {
      "status": 1,
      "target_temp": 45,
      "duration": 240
    }
          }
        ]
      }
    }
```

# Stop ACE drying 

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/multiColorBox, qos: 0
```
{
      "type": "multiColorBox",
      "action": "setDry",
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "timestamp": 1660201929871,
      "data": {
        "multi_color_box":[
          {
            "id": 0,
            "drying_status": {
      "status": 0
    }
          }
        ]
      }
    }
```

# HOMING

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/axis, qos: 0
```
{
      "type":"axis",
      "action":"move",
      "timestamp": 1660201929871,
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "data":{
        "axis":5,
        "move_type": 2,
        "distance": 0
      }
    }
```


# Z UP of 1mm

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/axis, qos: 0
```
{
      "type":"axis",
      "action":"move",
      "timestamp": 1660201929871,
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "data":{
        "axis":3,
        "move_type": 1,
        "distance": 1
      }
    }
```

# X 1mm

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/axis, qos: 0
```
{
      "type":"axis",
      "action":"move",
      "timestamp": 1660201929871,
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "data":{
        "axis":1,
        "move_type": 1,
        "distance": 1
      }
    }
```

# Y 1mm

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/axis, qos: 0
```
{
      "type":"axis",
      "action":"move",
      "timestamp": 1660201929871,
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "data":{
        "axis":2,
        "move_type": 1,
        "distance": 1
      }
    }
```

# X -1mm 

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/axis, qos: 0
```
{
      "type":"axis",
      "action":"move",
      "timestamp": 1660201929871,
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "data":{
        "axis":1,
        "move_type": 0,
        "distance": 1
      }
    }
```

# Disable motors

## topic: anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/axis, qos: 0
```
{
      "type":"axis",
      "action":"turnOff",
      "timestamp": 1660201929871,
      "msgid": "02fd3987-a2ff-244e-7c95-7fe257a9ef70",
      "data": null
    }
```

# Topic used during print :

## anycubic/anycubicCloud/v1/web/printer/20024/6e37df18dfd0a418547bb718bed3d131/print/report
```
{
  "type":"print",
  "action":"start",
  "timestamp":10298233,
  "msgid":"cc080f13-81e8-4326-8abb-6310725d4465",
  "state":"printing",
  "code":200,
  "msg":"done",
  "data":{"curr_layer":3,"filename":"XXX - Base_PLA_0.2_2h15m.gcode",
  "localtask":"",
  "print_time":33,
  "progress":3,
  "remain_time":102,
  "supplies_usage":4903,
  "taskid":"-1",
  "total_layers":45}
  }
```