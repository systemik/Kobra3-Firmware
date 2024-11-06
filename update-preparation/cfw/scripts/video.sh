#!/bin/sh

# Check if at least two arguments (URL and file path) are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <mjpg_stream_url> <save_directory> [make_video]"
    exit 1
fi

# Assign arguments to variables
URL="$1"
SAVE_DIR="$2"
MAKE_VIDEO="$3"

# Ensure the save directory exists; create it if it doesn't
mkdir -p "$SAVE_DIR"

# Find the highest numbered existing snapshot in the directory
FILE_PREFIX="snapshot_"
latest_number=$(ls "$SAVE_DIR"/$FILE_PREFIX*.jpg 2>/dev/null | grep -o '[0-9]\+' | sort -nr | head -n1)
new_number=$((latest_number + 1))

# Define the path for the new image file with incremental numbering
IMAGE_FILE="$SAVE_DIR/$FILE_PREFIX$new_number.jpg"

# Download the image from the MJPG stream and save it as a JPEG
curl -s "$URL" --output "$IMAGE_FILE"

# Check if the image was successfully saved
if [ $? -eq 0 ]; then
    echo "Snapshot saved as $IMAGE_FILE"
else
    echo "Failed to capture snapshot from $URL"
    exit 1
fi

# If the third argument is 'make_video', create an MP4 video from all snapshots in the directory
if [ "$MAKE_VIDEO" == "make_video" ]; then
    OUTPUT_VIDEO="$SAVE_DIR/timelapse.mp4"
    # Use ffmpeg to combine images into a video
    ffmpeg -framerate 12 -pattern_type glob -i "$SAVE_DIR/$FILE_PREFIX*.jpg" -c:v libx264 -r 30 -pix_fmt yuv420p "$OUTPUT_VIDEO"
    
    if [ $? -eq 0 ]; then
        echo "Video created successfully at $OUTPUT_VIDEO"
    else
        echo "Failed to create video."
        exit 1
    fi
fi

