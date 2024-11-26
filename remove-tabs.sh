#!/usr/bin/env bash

# Check if a filename is provided as an argument
if [ $# -eq 0 ]; then
  echo "Error: Please specify a filename as an argument."
  exit 1
fi

# Filename provided as the first argument
filename="$1"

sed -i.bak 's:\t\t:\t \t:g' "$filename"
sed -i 's:\t\t:\t \t:g' "$filename"
sed -i 's:\t::g' "$filename"

echo "Tabs replaced with spaces and empty cells filled with a space. Original file saved to $filename.bak"
