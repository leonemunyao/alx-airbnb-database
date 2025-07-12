-- =============================================================================
-- AIRBNB DATABASE - TABLE PARTITIONING FOR PERFORMANCE OPTIMIZATION
-- =============================================================================

-- Objective: Implement partitioning on the Booking table based on start_date
-- to improve query performance for large datasets

-- IMPORTANT NOTE: MySQL does not support foreign keys with partitioned tables
-- We will remove foreign keys from partitioned tables and rely on application-level constraints

-- STEP 1: Create a new partitioned Booking table without foreign keys
-- We'll use RANGE partitioning based on start_date for optimal performance

DROP TABLE IF EXISTS Booking_Partitioned;

CREATE TABLE Booking_Partitioned (
    booking_id CHAR(36) NOT NULL,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Note: Foreign keys removed due to MySQL partitioning limitation
    -- Application must ensure referential integrity
    PRIMARY KEY (booking_id, start_date)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p2027 VALUES LESS THAN (2028),
    PARTITION p2028 VALUES LESS THAN (2029),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- STEP 2: Alternative partitioning strategy - Monthly partitions for higher granularity
-- This approach provides better performance for date-range queries

DROP TABLE IF EXISTS Booking_Monthly_Partitioned;

CREATE TABLE Booking_Monthly_Partitioned (
    booking_id CHAR(36) NOT NULL,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Note: Foreign keys removed due to MySQL partitioning limitation
    PRIMARY KEY (booking_id, start_date)
)
PARTITION BY RANGE (TO_DAYS(start_date)) (
    PARTITION p202501 VALUES LESS THAN (TO_DAYS('2025-02-01')),
    PARTITION p202502 VALUES LESS THAN (TO_DAYS('2025-03-01')),
    PARTITION p202503 VALUES LESS THAN (TO_DAYS('2025-04-01')),
    PARTITION p202504 VALUES LESS THAN (TO_DAYS('2025-05-01')),
    PARTITION p202505 VALUES LESS THAN (TO_DAYS('2025-06-01')),
    PARTITION p202506 VALUES LESS THAN (TO_DAYS('2025-07-01')),
    PARTITION p202507 VALUES LESS THAN (TO_DAYS('2025-08-01')),
    PARTITION p202508 VALUES LESS THAN (TO_DAYS('2025-09-01')),
    PARTITION p202509 VALUES LESS THAN (TO_DAYS('2025-10-01')),
    PARTITION p202510 VALUES LESS THAN (TO_DAYS('2025-11-01')),
    PARTITION p202511 VALUES LESS THAN (TO_DAYS('2025-12-01')),
    PARTITION p202512 VALUES LESS THAN (TO_DAYS('2026-01-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- STEP 3: Migrate existing data from original Booking table (if it exists)
-- Copy data from the original table to the partitioned table

-- Check if original Booking table exists before attempting to copy data
-- This prevents errors if the table doesn't exist yet

SET @table_exists = (SELECT COUNT(*) 
                    FROM information_schema.tables 
                    WHERE table_schema = 'airbnb_db' 
                    AND table_name = 'Booking');

-- Only insert data if the original table exists
SET @sql = IF(@table_exists > 0, 
             'INSERT INTO Booking_Partitioned SELECT booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at FROM Booking',
             'SELECT "Original Booking table does not exist - skipping data migration" as message');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- STEP 4: Create a backup of original table and replace it (OPTIONAL)
-- Uncomment these lines if you want to replace the original table
-- WARNING: This will remove foreign key constraints from your database

-- RENAME TABLE Booking TO Booking_Original_Backup;
-- RENAME TABLE Booking_Partitioned TO Booking;

-- STEP 5: Create indexes on the partitioned table for optimal performance
-- Note: We're creating indexes on Booking_Partitioned (not replacing original table yet)

-- Foreign key equivalent indexes (since we can't have foreign keys)
CREATE INDEX idx_booking_partitioned_user_id ON Booking_Partitioned(user_id);
CREATE INDEX idx_booking_partitioned_property_id ON Booking_Partitioned(property_id);

-- Status index for filtering
CREATE INDEX idx_booking_partitioned_status ON Booking_Partitioned(status);

-- Date range indexes for partitioning optimization
CREATE INDEX idx_booking_partitioned_start_date ON Booking_Partitioned(start_date);
CREATE INDEX idx_booking_partitioned_end_date ON Booking_Partitioned(end_date);

-- Composite index for date range queries
CREATE INDEX idx_booking_partitioned_dates ON Booking_Partitioned(start_date, end_date);

-- Composite index for property availability queries
CREATE INDEX idx_booking_partitioned_property_dates ON Booking_Partitioned(property_id, start_date, end_date);

-- Creation date index for sorting
CREATE INDEX idx_booking_partitioned_created_at ON Booking_Partitioned(created_at);

-- STEP 6: Add partition management procedures for future maintenance

-- Drop procedure if it exists to avoid conflicts
DROP PROCEDURE IF EXISTS AddYearlyPartition;

-- Procedure to add yearly partitions automatically
DELIMITER //

CREATE PROCEDURE AddYearlyPartition(IN partition_year INT)
BEGIN
    SET @sql = CONCAT('ALTER TABLE Booking_Partitioned ADD PARTITION (PARTITION p', 
                     partition_year, 
                     ' VALUES LESS THAN (', 
                     partition_year + 1, 
                     '))');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- STEP 7: Query examples demonstrating partition benefits

-- Example 1: Query that benefits from partitioning (single partition access)
-- This query will only access the p2025 partition
SELECT b.booking_id, b.start_date, b.end_date, b.status
FROM Booking_Partitioned b
WHERE b.start_date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY b.start_date;

-- Example 2: Query across multiple partitions
-- This query will access p2025 and p2026 partitions
SELECT b.booking_id, b.start_date, b.total_price
FROM Booking_Partitioned b
WHERE b.start_date BETWEEN '2025-12-01' AND '2026-02-28'
ORDER BY b.start_date;

-- Example 3: Query with partition pruning demonstration
-- Use EXPLAIN FORMAT=JSON to see which partitions are accessed
EXPLAIN FORMAT=JSON
SELECT COUNT(*) as booking_count
FROM Booking_Partitioned b
WHERE b.start_date >= '2025-06-01' AND b.start_date < '2025-07-01';

-- STEP 8: Performance monitoring queries

-- Check partition information
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH,
    PARTITION_DESCRIPTION
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'airbnb_db' 
AND TABLE_NAME = 'Booking_Partitioned'
AND PARTITION_NAME IS NOT NULL;

-- STEP 9: Alternative Hash partitioning for even distribution
-- If date-based access patterns are unpredictable, hash partitioning can be used

/*
CREATE TABLE Booking_Hash_Partitioned (
    booking_id CHAR(36) NOT NULL,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Note: No foreign keys due to partitioning limitation
    PRIMARY KEY (booking_id)
)
PARTITION BY HASH(CRC32(booking_id))
PARTITIONS 8;
*/

-- STEP 10: Maintenance commands for partition management

-- Add a new partition for year 2029
-- CALL AddYearlyPartition(2029);

-- Drop old partitions (for data archival)
-- ALTER TABLE Booking_Partitioned DROP PARTITION p2024;

-- Reorganize partitions if needed
-- ALTER TABLE Booking_Partitioned REORGANIZE PARTITION p_future INTO (
--     PARTITION p2029 VALUES LESS THAN (2030),
--     PARTITION p_future VALUES LESS THAN MAXVALUE
-- );

-- STEP 11: Important notes about partitioned tables

/*
IMPORTANT LIMITATIONS AND CONSIDERATIONS:

1. FOREIGN KEY CONSTRAINTS:
   - MySQL does not support foreign keys with partitioned tables
   - Application must ensure referential integrity
   - Use triggers or application logic to maintain data consistency

2. REFERENTIAL INTEGRITY OPTIONS:
   a) Application-level validation
   b) Triggers to check references
   c) Periodic data validation jobs

3. BENEFITS OF PARTITIONING:
   - Partition pruning: Only relevant partitions scanned
   - Parallel processing: Operations can run on multiple partitions
   - Easier maintenance: Drop old partitions instead of DELETE
   - Better performance: Smaller partitions = faster queries

4. WHEN TO USE PARTITIONING:
   - Tables with millions of rows
   - Clear partitioning key (like date)
   - Queries frequently filter by partition key
   - Need for data archival/purging

5. TESTING PARTITIONING:
   - Compare performance before/after
   - Use EXPLAIN PARTITIONS to verify partition pruning
   - Monitor query performance over time
*/