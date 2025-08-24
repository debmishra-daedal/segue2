-- Author: Deb Mishra
-- Description: Creates the tables needed in Segue2 application.
-- Date: 2025-07-31
-- Table: network_usage
set schema 'dbo';
ALTER TABLE network_usage
ADD COLUMN IF NOT EXISTS load_file VARCHAR(100) DEFAULT 'network_usage.csv';

-- Drop the old unique constraint if it exists
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'network_usage_run_date_hour_interface_key'
            AND conrelid = 'network_usage'::regclass
    ) THEN
        ALTER TABLE network_usage
        DROP CONSTRAINT network_usage_run_date_hour_interface_key;
    END IF;
END$$;

-- Add new unique constraint including file_name
ALTER TABLE network_usage
ADD CONSTRAINT network_usage_run_date_hour_interface_file_name_key
UNIQUE (run_date, hour, interface, load_file);