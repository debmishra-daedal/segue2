# Build a ubuntu 22 image based on the segue2-ubuntu-22.04 image
FROM segue2-ubuntu-22.04:latest
#Install the packages needed for openvpn
RUN apt-get update && apt-get upgrade -y
RUN apt-get install openvpn easy-rsa iptables -y
RUN apt-get clean

# Make Easy-RSA directory
RUN make-cadir /etc/openvpn/easy-rsa

# Ensure the working directory exists
RUN mkdir -p /etc/openvpn
RUN mkdir -p /usr/local/bin
RUN echo "Checking if path points to usr/local/bin"
RUN echo $PATH

# Set the working directory
WORKDIR /etc/openvpn
COPY docker-entrypoint.sh /usr/local/bin
COPY client-file-script.sh /usr/local/bin
#Copy all files and folders in current source directory to the app folder
# Check contains of /usr/local/bin
RUN echo "Checking if entrypoint.sh is in /usr/local/bin"
RUN cd /usr/local/bin
RUN pwd
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/client-file-script.sh