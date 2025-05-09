# Start from your base Ubuntu 22.04 image
FROM segue2-ubuntu-22.04:latest

# Install Samba and envsubst (from gettext)
RUN apt-get update && \
    apt-get install -y samba gettext && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create Samba share directories
RUN mkdir -p /samba/public /samba/private

# Copy the Samba config template and entrypoint script
COPY smb.conf.template /etc/samba/smb.conf.template
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh