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

# Set the wallpaper
# termux-wallpaper-set "$WALLPAPER_PATH"
# if [ $? -ne 0 ]; then
#   echo "Failed to set wallpaper."
#   exit 1
# fi

# Set the ringtone
RINGTONE_URI=$(content insert --uri content://media/external/audio/media --bind data:text/plain:$RINGTONE_PATH --bind title:text/plain:"Custom Ringtone" --bind mime_type:text/plain:"audio/mp3" --bind is_ringtone:int:1)
if [ $? -ne 0 ]; then
  echo "Failed to set ringtone."
  exit 1
fi
settings put system ringtone $RINGTONE_URI

echo "Wallpaper and ringtone changed successfully."
