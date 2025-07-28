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
