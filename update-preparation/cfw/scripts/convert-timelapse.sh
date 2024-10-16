#!/bin/sh

# Directory containing the video files
SOURCE_DIR="/mnt/udisk/Time-lapse-Video"
CONVERTED_DIR="$SOURCE_DIR/converted"

# Ensure the "converted" subfolder exists
mkdir -p "$CONVERTED_DIR"

# Find the newest video file in the directory (based on modification time)
#NEWEST_FILE=$(find "$SOURCE_DIR" -type f \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.flv" -o -iname "*.webm" \) -print0 | xargs -0 ls -1 | while read file; do echo "$(stat -c %Y "$file") $file"; done | sort -n | tail -1 | cut -d' ' -f2-)
NEWEST_FILE=$(find "$SOURCE_DIR" -maxdepth 1 -type f -iname "*.mp4" -print0 | xargs -0 ls -1 | while read file; do echo "$(stat -c %Y "$file") $file"; done | sort -n | tail -1 | cut -d' ' -f2-)


# Check if a file was found
if [ -z "$NEWEST_FILE" ]; then
  echo "No video files found in $SOURCE_DIR"
  exit 1
fi

# Output file name (in the "converted" folder)
BASENAME=$(basename "$NEWEST_FILE")
OUTPUT_FILE="$CONVERTED_DIR/${BASENAME%.*}_converted.mp4"

# Convert the newest video file to MP4 (H.264 codec for video, AAC codec for audio)
ffmpeg -y -i "$NEWEST_FILE" -vcodec libx264 -acodec aac -strict -2 "$OUTPUT_FILE"

# Check if the conversion was successful
if [ $? -eq 0 ]; then
  echo "Conversion successful: $OUTPUT_FILE"
else
  echo "Conversion failed"
  exit 1
fi
