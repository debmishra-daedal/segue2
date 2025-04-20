# Build a slim ubuntu 24 image
FROM ubuntu:22.04
#create a working directory
#Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
# Set the locale
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

#Set the working directory
WORKDIR /ubuntu
#Copy all files and folders in current source directory to the app folder
COPY *.txt .
# Install core system utlities
RUN apt-get update && \
    xargs -a ubuntu-app-list.txt apt-get install -y --no-install-recommends && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*


