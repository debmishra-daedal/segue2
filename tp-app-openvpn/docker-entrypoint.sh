#!/bin/bash
set -e

# Set working directory
cd /etc/openvpn/easy-rsa

# Initialize PKI if not done yet
if [ ! -f pki/ca.crt ]; then
    ./easyrsa init-pki
    echo "yes" | ./easyrsa build-ca nopass
    ./easyrsa gen-dh
    ./easyrsa build-server-full server nopass
    ./easyrsa build-client-full client nopass
    openvpn --genkey --secret ta.key

    # Move keys to OpenVPN directory
    cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem ta.key /etc/openvpn/
fi
#create client profiles
# Build client certificate (replace 'client1' with your client name)
./easyrsa build-client-full $CLIENT_NAME nopass
# Copy the client certificate and key to the OpenVPN directory. For debugging only
# cp pki/ca.crt pki/issued/$CLIENT_NAME.crt pki/private/$CLIENT_NAME.key ta.key /etc/openvpn/client-configs/files
# Create the client configuration file from the client file script
echo "Creating client configuration file..."
/usr/local/bin/client-file-script.sh
cd /etc/openvpn/client-configs/files
ls -l
# Enable IP forwarding
echo "Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1

# Set up NAT for VPN traffic
echo "Setting up NAT (iptables)..."
if ! iptables -t nat -A POSTROUTING -s 192.168.171.0/24 -o eth0 -j MASQUERADE; then
    echo "Warning: Failed to set up iptables rules. Continuing anyway..."
fi
# Create OpenVPN server configuration file
/usr/local/bin/create-config-file.sh
# Start OpenVPN
echo "Starting OpenVPN server..."
chmod 644 /etc/openvpn/server.conf
exec openvpn --config /etc/openvpn/server.conf