# Build a slim ubuntu 24 image
FROM segue2-ubuntu-22.04:latest
#Set environment variables
ENV PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/config
ENV PLEX_MEDIA_SERVER_HOME=/usr/lib/plexmediaserver
ENV LD_LIBRARY_PATH=/usr/lib/plexmediaserver
ENV PLEX_MEDIA_SERVER_USER=plex
ENV PLEX_MEDIA_SERVER_GROUP=plex
ENV PLEX_DOWNLOAD_URL=https://downloads.plex.tv/plex-media-server-new
ENV PLEX_VERSION=1.41.6.9685-d301f511a
ENV PLEX_DISTRIBUTION=debian
ENV PLEX_ARCH=arm64

WORKDIR /plex
#Copy all files and folders in current source directory to the app folder
COPY *.sh .
COPY *welcome.mp4 .
# Give full access to all script files
RUN chmod +x *.sh
#Get the latest version of plex media server
RUN wget ${PLEX_DOWNLOAD_URL}/${PLEX_VERSION}/${PLEX_DISTRIBUTION}/plexmediaserver_${PLEX_VERSION}_${PLEX_ARCH}.deb
#Install plex media server
RUN dpkg -i plexmediaserver_${PLEX_VERSION}_${PLEX_ARCH}.deb
#Remove the deb file
RUN rm -rf plexmediaserver_${PLEX_VERSION}_${PLEX_ARCH}.deb
#expose the plex media server ports


