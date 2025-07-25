FROM alpine:3.19

# Install PostgreSQL 16 and client tools (PostgreSQL 17 is not available in Alpine 3.19)
RUN apk add --no-cache \
    postgresql16 \
    postgresql16-client \
    postgresql16-contrib \
    su-exec \
    tzdata

# Create directories and set permissions (postgres user already exists from package)
RUN mkdir -p /var/lib/postgresql/data && \
    mkdir -p /etc/postgresql && \
    mkdir -p /run/postgresql && \
    chown -R postgres:postgres /var/lib/postgresql && \
    chown -R postgres:postgres /run/postgresql && \
    chmod 700 /var/lib/postgresql/data && \
    chmod 755 /run/postgresql

# Copy configuration files and entrypoint script
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Ensure postgres user owns the config files and entrypoint
RUN chown postgres:postgres /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Set environment variables
ENV PGDATA=/var/lib/postgresql/data
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres

# Expose PostgreSQL port
EXPOSE 5432

# Set the default user
USER postgres

# Use custom entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]