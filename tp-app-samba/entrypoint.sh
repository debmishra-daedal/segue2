#!/bin/bash
set -e

# Check that required env variables are set
if [ -z "$SAMBA_USER" ] || [ -z "$SAMBA_PASSWORD" ]; then
    echo "ERROR: SAMBA_USER and SAMBA_PASSWORD environment variables must be set."
    exit 1
fi

# Replace placeholders in the smb.conf template with env values
envsubst < /etc/samba/smb.conf.template > /etc/samba/smb.conf

# Create Linux user if not exists
if ! id "$SAMBA_USER" &>/dev/null; then
    useradd -M -s /sbin/nologin "$SAMBA_USER"
    echo "Created Linux user: $SAMBA_USER"
fi

# Add user to 'sambashare' group if not already a member
if ! id -nG "$SAMBA_USER" | grep -qw "sambashare"; then
    usermod -aG sambashare "$SAMBA_USER"
    echo "Added $SAMBA_USER to sambashare group"
fi

# Create Samba user if not exists
if ! pdbedit -L | grep -qw "$SAMBA_USER"; then
    (echo "$SAMBA_PASSWORD"; echo "$SAMBA_PASSWORD") | smbpasswd -a -s "$SAMBA_USER"
    smbpasswd -e "$SAMBA_USER"
    echo "Created Samba user: $SAMBA_USER"
else
    echo "Samba user $SAMBA_USER already exists, skipping password setup"
fi

# Start Samba in the foreground
echo "Starting Samba..."
exec smbd --foreground --no-process-group