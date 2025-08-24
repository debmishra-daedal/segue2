-- Author: Deb Mishra
-- Description: Creates the tables needed in Segue2 application.
-- Date: 2025-07-27
-- Table: variable_list
CREATE TABLE IF NOT EXISTS dbo.variable_list (
    id SERIAL PRIMARY KEY,
        app_name VARCHAR(25) NOT NULL,
        variable_name VARCHAR(25) NOT NULL,
        variable_value VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE (app_name, variable_name)
);
-- Table: network_usage
CREATE TABLE IF NOT EXISTS dbo.network_usage (
    id SERIAL PRIMARY KEY,
    interface VARCHAR(25) NOT NULL,
    run_date DATE NOT NULL DEFAULT CURRENT_DATE,
    -- Store the hour as a TIME value (e.g., '01:00', '02:00')
    hour TIME NOT NULL CHECK (date_part('minute', hour) = 0 AND date_part('second', hour) = 0),
    received VARCHAR(25) NOT NULL,
    transmitted VARCHAR(25) NOT NULL,
    run_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (run_date, hour, interface)
);