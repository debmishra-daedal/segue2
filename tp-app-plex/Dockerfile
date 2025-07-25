FROM plexinc/pms-docker:latest

# Set environment variables
ENV PLEX_CLAIM=""
ENV PLEX_UID=1000
ENV PLEX_GID=1000
ENV TZ=Europe/Amsterdam

# Create necessary directories
RUN mkdir -p /config /transcode /media

# Set proper permissions
RUN chown -R ${PLEX_UID}:${PLEX_GID} /config /transcode /media

# Expose Plex port
EXPOSE 32400

# Volume mounts will be handled by docker-compose
VOLUME ["/config", "/transcode", "/media"]

# Use the default entrypoint from the base image