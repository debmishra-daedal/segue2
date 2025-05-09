#!/bin/bash
#This scripts sets the welcome video
# Ensure the /welcome directory exists
mkdir -p /welcome

# Move files matching *welcome.mp4 if they exist
shopt -s nullglob
for file in *welcome.mp4; do
  mv "$file" /welcome
done
shopt -u nullglob
#kill plex media server
pkill -f "Plex Media Server"
# This script is used to start the Plex Media Server in a Docker container.
exec /usr/lib/plexmediaserver/"Plex Media Server"
