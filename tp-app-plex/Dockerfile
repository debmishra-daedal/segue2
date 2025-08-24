FROM plexinc/pms-docker:latest

# Set environment variables
ENV PLEX_CLAIM=""
ENV PLEX_UID=1000
ENV PLEX_GID=1000
ENV TZ=Europe/Amsterdam

# Create necessary directories
RUN mkdir -p /config /transcode /media

# Copy custom entry-point script
COPY plex-entrypoint.sh /usr/local/bin/plex-entrypoint.sh
RUN chmod +x /usr/local/bin/plex-entrypoint.sh

# Set proper permissions
RUN chown -R ${PLEX_UID}:${PLEX_GID} /config /transcode /media

# Expose Plex port
EXPOSE 32400

# Volume mounts will be handled by docker-compose
VOLUME ["/config", "/transcode", "/media"]

# Use our custom entrypoint script
ENTRYPOINT ["/usr/local/bin/plex-entrypoint.sh"]