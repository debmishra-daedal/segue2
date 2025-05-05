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

# Run OpenVPN server
openvpn --config /etc/openvpn/server.conf