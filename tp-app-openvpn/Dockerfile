# Build a ubuntu 22 image based on the segue2-ubuntu-22.04 image
FROM segue2-ubuntu-22.04:latest
#Set environment variables

# Make Easy-RSA directory
RUN make-cadir /etc/openvpn/easy-rsa


# Ensure the working directory exists
RUN mkdir -p /etc/openvpn

# Set the working directory
WORKDIR /etc/openvpn
COPY server.conf .
#Copy all files and folders in current source directory to the app folder
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#Install the packages needed for openvpn
RUN apt-get update && apt-get upgrade -y
RUN apt-Install openvpn easy-rsa iptables -y
RUN apt-get clean

#Run the entrypoint script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]