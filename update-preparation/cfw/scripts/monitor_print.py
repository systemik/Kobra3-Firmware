import requests
import time

# Configuration
MOONRAKER_URL = "http://localhost:7125"  # Replace with your printer's IP address and port
TEMPERATURE_ENDPOINT = f"{MOONRAKER_URL}/printer/objects/query?heater_bed&extruder"
PRINT_JOB_STATUS_ENDPOINT = f"{MOONRAKER_URL}/printer/objects/query?print_stats"
POLLING_INTERVAL = 5  # seconds between each poll

def get_temperatures():
    """Fetches the bed and nozzle temperature from the Moonraker API."""
    try:
        response = requests.get(TEMPERATURE_ENDPOINT)
        response.raise_for_status()

        # Parse the JSON response
        data = response.json()
        bed_temp = data["result"]["status"]["heater_bed"]["temperature"]
        bed_target = data["result"]["status"]["heater_bed"]["target"]
        nozzle_temp = data["result"]["status"]["extruder"]["temperature"]
        nozzle_target = data["result"]["status"]["extruder"]["target"]

        return {
            "bed_temp": bed_temp,
            "bed_target": bed_target,
            "nozzle_temp": nozzle_temp,
            "nozzle_target": nozzle_target
        }
    except requests.RequestException as e:
        print(f"Error fetching temperature data from Moonraker API: {e}")
        return None

def get_print_job_status():
    """Fetches the current print job status and G-code file being executed."""
    try:
        response = requests.get(PRINT_JOB_STATUS_ENDPOINT)
        response.raise_for_status()

        # Parse the JSON response
        data = response.json()
        print_stats = data["result"]["status"]["print_stats"]
        filename = print_stats.get("filename")
        progress = print_stats.get("progress")
        state = print_stats.get("state")
        total_duration = print_stats.get("total_duration")
        print_duration = print_stats.get("print_duration")

        return {
            "filename": filename,
            "progress": progress,
            "state": state,
            "total_duration": total_duration,
            "print_duration": print_duration
        }
    except requests.RequestException as e:
        print(f"Error fetching print job data from Moonraker API: {e}")
        return None

def monitor_printer():
    """Continuously monitors the bed/nozzle temperature and current G-code execution."""
    print("Monitoring bed/nozzle temperature and print job status...")
    while True:
        temps = get_temperatures()
        print_job = get_print_job_status()

        # Print temperature data
        if temps:
            print(
                f"Bed: {temps['bed_temp']}°C (Target: {temps['bed_target']}°C) | "
                f"Nozzle: {temps['nozzle_temp']}°C (Target: {temps['nozzle_target']}°C)"
            )
        else:
            print("Failed to retrieve temperature data.")

        # Print current G-code job status
        if print_job:
            if print_job["state"] == "printing":
                print(
                    f"Printing: {print_job['filename']} | "
                    f"Progress: {print_job['progress'] * 100:.2f}% | "
                    f"Elapsed Time: {print_job['print_duration']}s | "
                    f"Total Duration: {print_job['total_duration']}s"
                )
            else:
                print(f"No active print job. State: {print_job['state']}")
        else:
            print("Failed to retrieve print job data.")

        time.sleep(POLLING_INTERVAL)

if __name__ == "__main__":
    monitor_printer()

