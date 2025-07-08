#!/bin/sh

FILENAME="pkglist.txt"

# Check if folder name argument is provided
if [ -z "$1" ]; then
  echo "Error: You must provide a folder name as an argument."
  echo "Usage: $0 <folder_name>"
  exit 1
fi

# Create folder if it does not exist
if [ ! -d "$1" ]; then
  mkdir -p "$1"
fi

# Save package list to the file
paru -Qqe > "$1/$FILENAME"

echo "Package list saved to $1/$FILENAME"
