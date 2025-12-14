-- MySQL initialization script for SMIS
-- This script runs when the MySQL container starts for the first time

-- Create database if it doesn't exist (should be created by environment variables)
CREATE DATABASE IF NOT EXISTS smis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE smis;

-- Grant permissions to the application user (should be created by environment variables)
GRANT ALL PRIVILEGES ON smis.* TO 'smis_user'@'%';
FLUSH PRIVILEGES;

-- Optional: Insert some sample data (this will be done by the application)
-- The application will create tables automatically via Hibernate
-- Sample data insertion is handled by the DataInitializerServlet
