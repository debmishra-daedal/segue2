#!/bin/bash
# Script to create server1.conf with the specified content
SAVEDIR=/etc/openvpn
cat <<EOL > $SAVEDIR/server.conf
port 1194
proto udp
dev tun

# Certificates and keys
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh.pem

# TLS auth (HMAC)
tls-auth /etc/openvpn/ta.key 0

# VPN subnet
server $IP_ADDR 255.255.255.0
## The followng lines are for a different configuration using specific IPS
# mode server
# tls-server
# ifconfig 192.168.171.1 255.255.255.0
# ifconfig-pool 192.168.171.231 192.168.171.239
# topology subnet
ifconfig-pool-persist /etc/openvpn/ipp.txt

# Redirect all client traffic through VPN
push "redirect-gateway def1 bypass-dhcp"

# Push DNS servers to clients
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.8.8"

# Keepalive settings (ping every 10 sec, restart if no ping for 120 sec)
keepalive 10 120

# Encryption cipher
cipher AES-256-CBC

# Persistence (don’t re-read keys/tun on restart)
persist-key
persist-tun

# Log files
log /var/log/openvpn/openvpn.log
status /var/log/openvpn/openvpn-status.log
verb $LOG_LEVEL
# Set the maximum number of clients
max-clients 10

# Enable client-to-client traffic (optional)
client-to-client

# Enable compression (optional, can improve speed)
;comp-lzo
EOL

echo "server1.conf has been created successfully with $IP_ADDR and is saved at $SAVEDIR."