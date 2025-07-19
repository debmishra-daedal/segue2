#!/bin/bash

# Plex initialization script
echo "Initializing Plex Media Server..."

# Ensure required directories exist
mkdir -p "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR:-/config}"
mkdir -p /tv /movies /others

# Create plex user and group if they don't exist
if ! getent group plex > /dev/null 2>&1; then
    groupadd -r plex
fi

if ! getent passwd plex > /dev/null 2>&1; then
    useradd -r -g plex -s /bin/false plex
fi

# Set ownership
chown -R plex:plex "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR:-/config}"
chown -R plex:plex /tv /movies /others

# Set up Plex claim if provided
if [ -n "$PLEX_CLAIM" ]; then
    echo "Setting up Plex claim token..."
    export PLEX_CLAIM="$PLEX_CLAIM"
fi

echo "Plex initialization complete."
