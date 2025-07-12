-- =============================================================================
-- PERFORMANCE MONITORING QUERIES
-- =============================================================================
-- This script contains all the practical queries for monitoring and optimizing 
-- database performance as documented in performance_monitoring.md

-- STEP 1: Enable Performance Monitoring
-- =============================================================================

-- Enable query profiling
SET profiling = 1;
SET profiling_history_size = 100;

-- Enable slow query log (requires SUPER privilege)
-- SET GLOBAL slow_query_log = 'ON';
-- SET GLOBAL long_query_time = 0.1;

-- Enable performance schema events
UPDATE performance_schema.setup_instruments 
SET ENABLED = 'YES', TIMED = 'YES' 
WHERE NAME LIKE 'statement/%';

UPDATE performance_schema.setup_consumers 
SET ENABLED = 'YES' 
WHERE NAME LIKE '%statements%';

-- STEP 2: Performance Analysis Queries
-- =============================================================================

-- Query 1: Property Search Performance Test
-- Original inefficient query
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    u.first_name,
    u.last_name,
    AVG(r.rating) as avg_rating
FROM Property p
JOIN User u ON p.host_id = u.user_id
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location LIKE '%New York%'
AND p.pricepernight BETWEEN 100 AND 300
GROUP BY p.property_id, p.name, p.description, p.location, p.pricepernight, u.first_name, u.last_name
ORDER BY avg_rating DESC, p.pricepernight ASC
LIMIT 20;

-- Analyze the above query
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    u.first_name,
    u.last_name,
    AVG(r.rating) as avg_rating
FROM Property p
JOIN User u ON p.host_id = u.user_id
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location LIKE '%New York%'
AND p.pricepernight BETWEEN 100 AND 300
GROUP BY p.property_id, p.name, p.description, p.location, p.pricepernight, u.first_name, u.last_name
ORDER BY avg_rating DESC, p.pricepernight ASC
LIMIT 20;

-- Query 2: User Booking History Performance Test
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name as property_name,
    p.location,
    u.first_name as host_name
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
JOIN User u ON p.host_id = u.user_id
WHERE b.user_id = 'user123'
ORDER BY b.start_date DESC;

-- Analyze booking history query
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.name as property_name,
    p.location,
    u.first_name as host_name
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
JOIN User u ON p.host_id = u.user_id
WHERE b.user_id = 'user123'
ORDER BY b.start_date DESC;

-- Query 3: Property Availability Check Performance Test
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM Property p
WHERE p.property_id NOT IN (
    SELECT b.property_id
    FROM Booking b
    WHERE b.status IN ('confirmed', 'pending')
    AND (
        (b.start_date <= '2025-08-01' AND b.end_date >= '2025-08-01')
        OR (b.start_date <= '2025-08-15' AND b.end_date >= '2025-08-15')
        OR (b.start_date >= '2025-08-01' AND b.end_date <= '2025-08-15')
    )
)
AND p.location LIKE '%Miami%';

-- Analyze availability check query
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM Property p
WHERE p.property_id NOT IN (
    SELECT b.property_id
    FROM Booking b
    WHERE b.status IN ('confirmed', 'pending')
    AND (
        (b.start_date <= '2025-08-01' AND b.end_date >= '2025-08-01')
        OR (b.start_date <= '2025-08-15' AND b.end_date >= '2025-08-15')
        OR (b.start_date >= '2025-08-01' AND b.end_date <= '2025-08-15')
    )
)
AND p.location LIKE '%Miami%';

-- STEP 3: Performance Monitoring Queries
-- =============================================================================

-- Show query profiles
SHOW PROFILES;

-- Top 10 slowest queries from performance schema
SELECT 
    DIGEST_TEXT,
    COUNT_STAR,
    AVG_TIMER_WAIT/1000000000 as avg_exec_time_sec,
    MAX_TIMER_WAIT/1000000000 as max_exec_time_sec,
    SUM_TIMER_WAIT/1000000000 as total_exec_time_sec
FROM performance_schema.events_statements_summary_by_digest
ORDER BY avg_exec_time_sec DESC
LIMIT 10;

-- Index usage statistics
SELECT 
    OBJECT_SCHEMA,
    OBJECT_NAME,
    INDEX_NAME,
    COUNT_FETCH,
    COUNT_INSERT,
    COUNT_UPDATE,
    COUNT_DELETE
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA = 'airbnb_db'
ORDER BY COUNT_FETCH DESC;

-- STEP 4: Optimization Implementation
-- =============================================================================

-- Create optimized indexes
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);
CREATE INDEX idx_property_location_prefix ON Property(location(20));
CREATE INDEX idx_property_host ON Property(host_id);

CREATE INDEX idx_booking_user_date ON Booking(user_id, start_date DESC);
CREATE INDEX idx_booking_availability ON Booking(property_id, status, start_date, end_date);
CREATE INDEX idx_booking_date_range ON Booking(start_date, end_date);

CREATE INDEX idx_review_property_rating ON Review(property_id, rating);
CREATE INDEX idx_review_user_property ON Review(user_id, property_id);

-- STEP 5: Optimized Query Versions
-- =============================================================================

-- Optimized Property Search Query
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    u.first_name,
    u.last_name,
    COALESCE(r.avg_rating, 0) as avg_rating
FROM Property p
JOIN User u ON p.host_id = u.user_id
LEFT JOIN (
    SELECT property_id, AVG(rating) as avg_rating
    FROM Review
    GROUP BY property_id
) r ON p.property_id = r.property_id
WHERE p.location LIKE 'New York%'  -- Removed leading wildcard
AND p.pricepernight BETWEEN 100 AND 300
ORDER BY avg_rating DESC, p.pricepernight ASC
LIMIT 20;

-- Optimized Availability Check Query
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM Property p
WHERE p.location LIKE 'Miami%'
AND NOT EXISTS (
    SELECT 1
    FROM Booking b
    WHERE b.property_id = p.property_id
    AND b.status IN ('confirmed', 'pending')
    AND b.start_date <= '2025-08-15'
    AND b.end_date >= '2025-08-01'
);

-- STEP 6: Performance Comparison
-- =============================================================================

-- Test optimized queries with EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    u.first_name,
    u.last_name,
    COALESCE(r.avg_rating, 0) as avg_rating
FROM Property p
JOIN User u ON p.host_id = u.user_id
LEFT JOIN (
    SELECT property_id, AVG(rating) as avg_rating
    FROM Review
    GROUP BY property_id
) r ON p.property_id = r.property_id
WHERE p.location LIKE 'New York%'
AND p.pricepernight BETWEEN 100 AND 300
ORDER BY avg_rating DESC, p.pricepernight ASC
LIMIT 20;

EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.pricepernight
FROM Property p
WHERE p.location LIKE 'Miami%'
AND NOT EXISTS (
    SELECT 1
    FROM Booking b
    WHERE b.property_id = p.property_id
    AND b.status IN ('confirmed', 'pending')
    AND b.start_date <= '2025-08-15'
    AND b.end_date >= '2025-08-01'
);

-- STEP 7: Ongoing Monitoring Setup
-- =============================================================================

-- Create performance monitoring view
CREATE OR REPLACE VIEW performance_monitoring AS
SELECT 
    DIGEST_TEXT,
    COUNT_STAR as execution_count,
    AVG_TIMER_WAIT/1000000000 as avg_response_time_sec,
    MAX_TIMER_WAIT/1000000000 as max_response_time_sec,
    SUM_ROWS_EXAMINED/COUNT_STAR as avg_rows_examined,
    SUM_ROWS_SENT/COUNT_STAR as avg_rows_returned
FROM performance_schema.events_statements_summary_by_digest
WHERE DIGEST_TEXT IS NOT NULL
ORDER BY avg_response_time_sec DESC;

-- Performance alerts query
SELECT 
    'PERFORMANCE_ALERT' as alert_type,
    DIGEST_TEXT,
    AVG_TIMER_WAIT/1000000000 as avg_response_time_sec,
    COUNT_STAR as execution_count
FROM performance_schema.events_statements_summary_by_digest
WHERE AVG_TIMER_WAIT/1000000000 > 1.0
AND COUNT_STAR > 10
ORDER BY avg_response_time_sec DESC;

-- Query response time distribution
SELECT 
    CASE 
        WHEN AVG_TIMER_WAIT < 10000000 THEN '<10ms'
        WHEN AVG_TIMER_WAIT < 100000000 THEN '10-100ms'
        WHEN AVG_TIMER_WAIT < 1000000000 THEN '100ms-1s'
        WHEN AVG_TIMER_WAIT < 10000000000 THEN '1-10s'
        ELSE '>10s'
    END as response_time_range,
    COUNT(*) as query_count
FROM performance_schema.events_statements_summary_by_digest
GROUP BY response_time_range
ORDER BY response_time_range;

-- Check for unused indexes
SELECT 
    OBJECT_SCHEMA,
    OBJECT_NAME,
    INDEX_NAME
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA = 'airbnb_db'
AND INDEX_NAME IS NOT NULL
AND COUNT_FETCH = 0
AND COUNT_INSERT = 0
AND COUNT_UPDATE = 0
AND COUNT_DELETE = 0;

-- STEP 8: Maintenance Tasks
-- =============================================================================

-- Update table statistics
ANALYZE TABLE Property, Booking, Review, User;

-- Check index cardinality
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    CARDINALITY,
    SUB_PART,
    NULLABLE,
    INDEX_TYPE
FROM information_schema.statistics
WHERE TABLE_SCHEMA = 'airbnb_db'
ORDER BY TABLE_NAME, INDEX_NAME;

-- Table size analysis
SELECT 
    TABLE_NAME,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) as table_size_mb,
    ROUND((DATA_LENGTH / 1024 / 1024), 2) as data_size_mb,
    ROUND((INDEX_LENGTH / 1024 / 1024), 2) as index_size_mb,
    TABLE_ROWS
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'airbnb_db'
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;

-- STEP 9: Sample Data for Testing (Optional)
-- =============================================================================

-- Insert sample data if tables are empty for testing
-- Note: These are just examples - adjust based on your actual data structure

/*
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES 
    (UUID(), 'host1', 'Cozy Apartment', 'Nice place', 'New York, NY', 150),
    (UUID(), 'host2', 'Beach House', 'Ocean view', 'Miami, FL', 250),
    (UUID(), 'host3', 'City Loft', 'Downtown', 'New York, NY', 200);

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES 
    (UUID(), 'prop1', 'user123', '2025-08-01', '2025-08-05', 600, 'confirmed'),
    (UUID(), 'prop2', 'user456', '2025-08-10', '2025-08-15', 1250, 'pending');

INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES 
    (UUID(), 'prop1', 'user123', 5, 'Great place!'),
    (UUID(), 'prop2', 'user456', 4, 'Good location');
*/

-- STEP 10: Results Analysis
-- =============================================================================

-- Compare execution times before and after optimization
-- Run this periodically to track improvements

SELECT 
    'Performance Summary' as metric_type,
    COUNT(*) as total_queries,
    AVG(AVG_TIMER_WAIT/1000000000) as avg_response_time_sec,
    MIN(AVG_TIMER_WAIT/1000000000) as min_response_time_sec,
    MAX(AVG_TIMER_WAIT/1000000000) as max_response_time_sec
FROM performance_schema.events_statements_summary_by_digest
WHERE DIGEST_TEXT IS NOT NULL;

-- Check current performance monitoring view
SELECT * FROM performance_monitoring LIMIT 10;

-- Final recommendations based on current state
SELECT 
    'INDEX_RECOMMENDATION' as recommendation_type,
    CONCAT('Consider adding index on ', OBJECT_NAME, ' for columns frequently used in WHERE clauses') as recommendation
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA = 'airbnb_db'
AND INDEX_NAME IS NULL
AND COUNT_FETCH > 1000;
