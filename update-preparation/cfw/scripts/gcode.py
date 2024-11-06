import asyncio
import websockets
import json
import subprocess


# Moonraker WebSocket URL (default is ws://localhost:7125/websocket)
MOONRAKER_WS_URL = "ws://localhost:7125/websocket"

# Path to the shell script
SHELL_SCRIPT_PATH = "/useremain/cfw/scripts/video.sh"
SNAPSHOT_URL = "http://192.168.1.233:8080/?action=snapshot"
TARGET_FOLDER = "/mnt/udisk/custom_timelape"
MAKE_VIDEO = "make_video"

async def listen_to_gcode_responses():
    async with websockets.connect(MOONRAKER_WS_URL) as websocket:
        # Subscribe to `notify_gcode_response` events
        subscribe_message = json.dumps({
            "jsonrpc": "2.0",
            "method": "printer.notify_gcode_response",
            "params": {},
            "id": 1
        })
        await websocket.send(subscribe_message)
        
        print("Subscribed to G-code responses. Listening for executed G-code...")

        while True:
            # Listen for messages from Moonraker
            message = await websocket.recv()
            data = json.loads(message)

            # Check if the message contains a G-code response event
            if "method" in data and data["method"] == "notify_gcode_response":
                gcode_response = data["params"][0]
                #print(f"Received G-code response: {gcode_response}")

                # Check for specific G-code response (e.g., M100)
                if "ECHO" in gcode_response:
                    print("Take Snapshot Image...")
                    # Execute the shell script
                    try:
                        result = subprocess.run([SHELL_SCRIPT_PATH,SNAPSHOT_URL,TARGET_FOLDER], check=True)
                        print("Shell script executed successfully.")
                    except subprocess.CalledProcessError as e:
                        print(f"Error executing shell script: {e}")

                # Check for specific G-code response (e.g., M100)
                if "CUSTOM_TIMELAPSE" in gcode_response:
                    print("Take Snapshot Image...")
                    # Execute the shell script
                    try:
                        result = subprocess.run([SHELL_SCRIPT_PATH,SNAPSHOT_URL,TARGET_FOLDER], check=True)
                        print("Shell script executed successfully.")
                    except subprocess.CalledProcessError as e:
                        print(f"Error executing shell script: {e}")

                # Check for specific G-code response (e.g., M100)
                if "CUSTOM_VIDEO" in gcode_response:
                    print("Create video...")
                    # Execute the shell script
                    try:
                        result = subprocess.run([SHELL_SCRIPT_PATH,SNAPSHOT_URL,TARGET_FOLDER,MAKE_VIDEO], check=True)
                        print("Shell script executed successfully.")
                    except subprocess.CalledProcessError as e:
                        print(f"Error executing shell script: {e}")


async def main():
    await listen_to_gcode_responses()

# Run the WebSocket listener
asyncio.run(main())

