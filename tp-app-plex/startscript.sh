#!/bin/bash

# Source the initialization script
source ./init-plex.sh

#This scripts sets the welcome video
# Ensure the /welcome directory exists
mkdir -p /welcome

# Move files matching *welcome.mp4 if they exist
shopt -s nullglob
for file in *welcome.mp4; do
  mv "$file" /welcome/
done
shopt -u nullglob

#kill plex media server if already running
echo "Killing Plex Media Server if already running"
pkill -f "Plex Media Server" || true

# This script is used to start the Plex Media Server in a Docker container.
echo "Starting Plex Media Server in Docker container"

# Set up environment
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR:-/config}"
export PLEX_MEDIA_SERVER_HOME="${PLEX_MEDIA_SERVER_HOME:-/usr/lib/plexmediaserver}"
export LD_LIBRARY_PATH="${PLEX_MEDIA_SERVER_HOME}"

# Change to Plex directory and start as plex user
source ./diagnose.sh
cd "${PLEX_MEDIA_SERVER_HOME}"
exec su -s /bin/bash plex -c "\"${PLEX_MEDIA_SERVER_HOME}/Plex Media Server\""
