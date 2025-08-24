# Flyway Migration Guide for Segue2

This guide explains how to use Flyway migrations in the Segue2 project for database schema management.

## Overview

Flyway is a database migration tool that helps manage database schema changes in a version-controlled way. It automatically applies SQL migration files to keep your database schema in sync with your application.

## How `migrate.sh` Works

The script is a wrapper around Flyway commands that provides:

- **Colored output** for better readability
- **Safety checks** before running commands
- **Database readiness verification**
- **Confirmation prompts** for destructive operations

## Available Commands

### 1. **Basic Migration Operations**

```bash
./pgdb/migrate.sh migrate    # Apply pending migrations
./pgdb/migrate.sh info       # Show migration status and history
./pgdb/migrate.sh validate   # Validate applied migrations
./pgdb/migrate.sh status     # Quick status overview
```

### 2. **Advanced Operations**

```bash
./pgdb/migrate.sh baseline   # Mark database as migrated up to a version
./pgdb/migrate.sh clean      # WIPE ALL DATA (dangerous!)
```

## Migration Scenarios & How to Handle Them

### **Scenario 1: Normal Migration (Adding New Changes)**

```bash
# 1. Create new migration file: V0.2__add_new_table.sql
# 2. Run migrations
./pgdb/migrate.sh migrate
```

### **Scenario 2: Rollback (Undoing Changes)**

**Important**: Flyway Community Edition doesn't support automatic rollbacks. You have two options:

#### Option A: Manual Rollback (Recommended)

```bash
# 1. Create a new migration that undoes the changes
# Example: V0.3__rollback_previous_changes.sql
# Content: DROP TABLE IF EXISTS new_table;

# 2. Apply the rollback migration
./pgdb/migrate.sh migrate
```

#### Option B: Clean and Re-run (DANGEROUS - Loses all data)

```bash
# WARNING: This deletes ALL data!
./pgdb/migrate.sh clean
./pgdb/migrate.sh migrate
```

### **Scenario 3: Refresh Views/Functions**

```bash
# 1. Create a new migration for view/function updates
# Example: V0.4__refresh_views.sql
# Content:
# DROP VIEW IF EXISTS my_view;
# CREATE VIEW my_view AS SELECT * FROM table;

# 2. Apply the migration
./pgdb/migrate.sh migrate
```

### **Scenario 4: Database Reset (Development)**

```bash
# Complete reset - removes all data and migrations
./pgdb/migrate.sh clean
./pgdb/migrate.sh migrate
```

### **Scenario 5: Check Migration Status**

```bash
# See what migrations are pending/applied
./pgdb/migrate.sh info

# Quick status check
./pgdb/migrate.sh status
```

## Best Practices for Your Workflow

### **1. Always Check Status First**

```bash
./pgdb/migrate.sh info
```

### **2. Validate Before Deploying**

```bash
./pgdb/migrate.sh validate
```

### **3. For Development/Testing**

```bash
# Reset everything
./pgdb/migrate.sh clean
./pgdb/migrate.sh migrate
```

### **4. For Production**

```bash
# Only run pending migrations
./pgdb/migrate.sh migrate
```

## Migration File Naming Convention

```
V<version>__<description>.sql
```

**Important**: Note the **double underscore** `__` between version and description.

Examples:

- `V0__init.sql`
- `V0.1__create_table_variablelist.sql`
- `V0.2__add_user_table.sql`
- `V0.3__rollback_user_table.sql`

## What Each Command Does Behind the Scenes

### **migrate**

```bash
docker-compose run --rm flyway migrate
```

- Applies all pending migrations in order
- Updates the `flyway_schema_history` table
- Fails if any migration fails

### **info**

```bash
docker-compose run --rm flyway info
```

- Shows all migrations (applied, pending, failed)
- Displays version history
- Shows current schema version

### **validate**

```bash
docker-compose run --rm flyway validate
```

- Checks that applied migrations haven't been modified
- Ensures migration integrity
- Fails if checksums don't match

### **clean**

```bash
docker-compose run --rm flyway clean
```

- **DANGEROUS**: Removes all objects from the database
- Deletes all tables, views, functions, etc.
- Resets migration history

## Safety Features in the Script

1. **Database readiness check** - Ensures PostgreSQL is running
2. **Confirmation prompts** - For destructive operations
3. **Error handling** - Exits on failure
4. **Colored output** - Easy to read status messages

## Example Workflow for Adding a New Feature

```bash
# 1. Create new migration file
# V0.2__add_feature_table.sql

# 2. Check current status
./pgdb/migrate.sh info

# 3. Apply the migration
./pgdb/migrate.sh migrate

# 4. Verify it worked
./pgdb/migrate.sh info
```

## Current Migration Files

- `V0__init.sql` - Creates the `dbo` schema
- `V0.1__create_table_variablelist.sql` - Creates tables for the application

## Docker Compose Integration

The Flyway service is configured in `docker-compose.yml` to:

- Automatically run migrations when services start
- Connect to the PostgreSQL database
- Use the same environment variables as the database service
- Mount migration files from `./pgdb/migrations` to `/flyway/sql/migrations`

## Troubleshooting

### **Migration Files Not Detected**

- Check file naming convention (double underscore `__`)
- Ensure files are in the correct directory (`pgdb/migrations/`)
- Verify file extensions are `.sql`

### **Database Connection Issues**

- Ensure PostgreSQL container is running: `docker-compose ps pgdb`
- Check environment variables in `var/pgdb.env`
- Verify database is ready: `docker-compose exec pgdb pg_isready`

### **Migration Fails**

- Check migration file syntax
- Ensure no conflicting changes
- Review error messages in Flyway output

## Environment Variables

The following environment variables are used by Flyway:

- `POSTGRES_DB` - Database name (default: postgres)
- `POSTGRES_USER` - Database user (default: postgres)
- `POSTGRES_PASSWORD` - Database password (required)

These are loaded from `var/pgdb.env` in the Docker Compose configuration.
