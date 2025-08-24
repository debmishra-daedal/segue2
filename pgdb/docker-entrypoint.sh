#!/bin/sh
set -e

echo "=== PostgreSQL Container Starting ==="
echo "Data Directory: ${PGDATA}"
echo "=================================="

# Ensure runtime directory exists
mkdir -p /run/postgresql
chown postgres:postgres /run/postgresql
chmod 755 /run/postgresql

# Initialize database if it does not exist
echo "Checking if database initialization is needed..."
echo "PGDATA: $PGDATA"
echo "PG_VERSION file: $PGDATA/PG_VERSION"
if [ -f "$PGDATA/PG_VERSION" ]; then
    echo "PG_VERSION exists, content: $(cat $PGDATA/PG_VERSION)"
else
    echo "PG_VERSION does not exist"
fi

if [ ! -s "$PGDATA/PG_VERSION" ]; then
    echo "Initializing database..."
    
    # Check if admin password is provided
    if [ -z "$POSTGRES_PASSWORD" ]; then
        echo "ERROR: POSTGRES_PASSWORD must be set"
        exit 1
    fi
    
    # Initialize database with admin password
    echo "$POSTGRES_PASSWORD" | initdb --username="$POSTGRES_USER" --pwfile=/dev/stdin --auth-local=md5 --auth-host=md5
    
    echo "Database initialization completed."
    
    # Flag to create custom database on first startup
    touch "$PGDATA/.create_custom_db"
fi

# Create custom database if needed (always check)
echo "Checking for custom database: $POSTGRES_DB"
if [ -n "$POSTGRES_DB" ] && [ "$POSTGRES_DB" != "postgres" ]; then
    echo "Starting PostgreSQL temporarily to check/create custom database..."
    postgres -c config_file=/etc/postgresql/postgresql.conf -c hba_file=/etc/postgresql/pg_hba.conf &
    PG_PID=$!
    
    # Wait for PostgreSQL to be ready
    echo "Waiting for PostgreSQL to start..."
    sleep 8
    
    # Check if database exists
    echo "Checking if database $POSTGRES_DB exists..."
    DB_EXISTS=$(psql -U "$POSTGRES_USER" -h localhost -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$POSTGRES_DB'" 2>/dev/null || echo "")
    
    if [ -z "$DB_EXISTS" ]; then
        echo "Database $POSTGRES_DB does not exist, creating..."
        psql -U "$POSTGRES_USER" -h localhost -d postgres -c "CREATE DATABASE \"$POSTGRES_DB\";" || echo "Failed to create database"
        echo "Database $POSTGRES_DB created successfully."
    else
        echo "Database $POSTGRES_DB already exists."
    fi
    
    # Stop the temporary instance
    echo "Stopping temporary PostgreSQL instance..."
    kill $PG_PID
    wait $PG_PID 2>/dev/null || true
    sleep 2
fi

# Display connection details summary
echo ""
echo "==============================================="
echo "       PostgreSQL Connection Details"
echo "==============================================="
echo "Container Name: $(hostname)"
echo "Container IP: $(hostname -i 2>/dev/null || echo 'unknown')"
echo "Network Range: ${SEGUE2_NETWORK:-192.168.171.0/24}"
echo "PostgreSQL Version: $(postgres --version | awk '{print $3}')"
echo "Host Port: ${POSTGRES_PORT:-5432}"
echo "Internal Port: 5432"
echo "Admin User: ${POSTGRES_USER}"
echo "Admin Password: ${POSTGRES_PASSWORD}"
echo "Custom Database: ${POSTGRES_DB}"
echo ""
echo "Connection Examples:"
echo "  From Host Machine:"
echo "    psql -h 127.0.0.1 -p ${POSTGRES_PORT:-5432} -U ${POSTGRES_USER} -d ${POSTGRES_DB}"
echo "  From Container Network:"
echo "    psql -h $(hostname) -p 5432 -U ${POSTGRES_USER} -d ${POSTGRES_DB}"
echo "  From Inside Container:"
echo "    psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}"
echo "==============================================="
echo ""

# Start PostgreSQL
echo "Starting PostgreSQL server..."
exec postgres -c config_file=/etc/postgresql/postgresql.conf -c hba_file=/etc/postgresql/pg_hba.conf
