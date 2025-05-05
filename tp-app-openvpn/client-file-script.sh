#!/bin/bash
# Usage: ./create-ovpn.sh clientname outputfile.ovpn

# CLIENT_NAME=$1
# OUTPUT_FILE=$2

# if [ -z "$CLIENT_NAME" ] || [ -z "$OUTPUT_FILE" ]; then
#     echo "Usage: $0 <client-name> <output-file.ovpn>"
#     exit 1
# fi

# Paths (adjust if needed)
EASYRSA_DIR="/etc/openvpn/easy-rsa"
OUTPUT_DIR="/etc/openvpn/client-configs/files"

CA_CERT="$EASYRSA_DIR/pki/ca.crt"
CLIENT_CERT="$EASYRSA_DIR/pki/issued/$CLIENT_NAME.crt"
CLIENT_KEY="$EASYRSA_DIR/pki/private/$CLIENT_NAME.key"
TA_KEY="/etc/openvpn/ta.key"

# Start writing .ovpn file
cat > "$OUTPUT_DIR/$OUTPUT_FILE" <<EOF
client
dev tun
proto udp
remote $REMOTE_SERVER $REMOTE_PORT
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
verb 3
key-direction 1

<ca>
$(cat "$CA_CERT")
</ca>

<cert>
$(awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' "$CLIENT_CERT")
</cert>

<key>
$(cat "$CLIENT_KEY")
</key>

<tls-auth>
$(cat "$TA_KEY")
</tls-auth>
EOF

echo "Created $OUTPUT_FILE in $OUTPUT_DIR"