#!/bin/bash

# URLs to download the files from
WALLPAPER_URL="https://file-examples.com/storage/fed5266c9966708dcaeaea6/2017/10/file_example_JPG_100kB.jpg"
RINGTONE_URL="https://onlinetestcase.com/wp-content/uploads/2023/06/100-KB-MP3.mp3"

# Paths to save the downloaded files
WALLPAPER_PATH="/sdcard/Download/wallpaper.jpg"
RINGTONE_PATH="/sdcard/Download/ringtone.mp3"

# Ensure Termux has storage access
termux-setup-storage

# Download the wallpaper
curl -o "$WALLPAPER_PATH" "$WALLPAPER_URL"
if [ $? -ne 0 ]; then
  echo "Failed to download wallpaper."
  exit 1
fi

# Download the ringtone
curl -o "$RINGTONE_PATH" "$RINGTONE_URL"
if [ $? -ne 0 ]; then
  echo "Failed to download ringtone."
  exit 1
fi

# Set the wallpaper using termux-wallpaper command
termux-wallpaper -f "$WALLPAPER_PATH"
if [ $? -ne 0 ]; then
  echo "Failed to set wallpaper."
  exit 1
fi

# Insert the ringtone into the media store
RINGTONE_URI=$(termux-media-scan "$RINGTONE_PATH")
if [ $? -ne 0 ]; then
  echo "Failed to scan media."
  exit 1
fi

# Ensure the ringtone URI is set properly
RINGTONE_URI=$(content query --uri content://media/external/audio/media --projection _id --where "data='$RINGTONE_PATH'" | grep _id | awk -F= '{print $2}')
if [ -z "$RINGTONE_URI" ]; then
  echo "Failed to get ringtone URI."
  exit 1
fi

RINGTONE_URI="content://media/external/audio/media/$RINGTONE_URI"

# Set the ringtone
settings put system ringtone $RINGTONE_URI
if [ $? -ne 0 ]; then
  echo "Failed to set ringtone."
  exit 1
fi

echo "Wallpaper and ringtone changed successfully."
