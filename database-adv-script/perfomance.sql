-- =============================================================================
-- AIRBNB DATABASE - QUERY PERFORMANCE OPTIMIZATION
-- =============================================================================

-- Task 1: Initial complex query retrieving bookings with user, property, and payment details
-- This query demonstrates a complex multi-table JOIN that may need optimization

-- Initial Query (Before Optimization)
-- This query retrieves comprehensive booking information including all related details
EXPLAIN
SELECT 
    -- Booking details
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- User details (guest who made the booking)
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    
    -- Host details (property owner)
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    h.phone_number AS host_phone,
    
    -- Payment details
    py.payment_id,
    py.amount AS payment_amount,
    py.payment_date,
    py.payment_method
    
FROM Booking b
    -- Join with User table to get guest details
    INNER JOIN User u ON b.user_id = u.user_id
    
    -- Join with Property table to get property details
    INNER JOIN Property p ON b.property_id = p.property_id
    
    -- Join with User table again to get host details
    INNER JOIN User h ON p.host_id = h.user_id
    
    -- Left join with Payment table to get payment details (some bookings might not have payments yet)
    LEFT JOIN Payment py ON b.booking_id = py.booking_id

-- Add WHERE clause with AND conditions for realistic filtering
WHERE b.status IN ('confirmed', 'pending') 
    AND b.start_date >= '2025-01-01' 
    AND b.start_date <= '2025-12-31'
    AND p.pricepernight >= 50
    AND u.role = 'guest'
    
-- Order by booking creation date (most recent first)
ORDER BY b.created_at DESC, b.booking_id ASC;

-- =============================================================================
-- PERFORMANCE ANALYSIS USING EXPLAIN
-- =============================================================================

-- Step 1: Analyze the initial complex query performance
EXPLAIN
SELECT 
    -- Booking details
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    
    -- User details (guest who made the booking)
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    
    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.location AS property_location,
    p.pricepernight,
    p.created_at AS property_created_at,
    p.updated_at AS property_updated_at,
    
    -- Host details (property owner)
    h.user_id AS host_id,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email,
    h.phone_number AS host_phone,
    
    -- Payment details
    py.payment_id,
    py.amount AS payment_amount,
    py.payment_date,
    py.payment_method
    
FROM Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment py ON b.booking_id = py.booking_id

WHERE b.status IN ('confirmed', 'pending') 
    AND b.start_date >= '2025-01-01' 
    AND b.start_date <= '2025-12-31'
    AND p.pricepernight >= 50
    AND u.role = 'guest'
    
ORDER BY b.created_at DESC, b.booking_id ASC;

-- Step 2: Detailed analysis with EXPLAIN ANALYZE for execution statistics
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total,
    b.status AS booking_status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.location AS property_location,
    p.pricepernight,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    py.amount AS payment_amount,
    py.payment_method
    
FROM Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment py ON b.booking_id = py.booking_id

WHERE b.status IN ('confirmed', 'pending') 
    AND b.start_date >= '2025-01-01' 
    AND b.start_date <= '2025-12-31'
    AND p.pricepernight >= 50
    AND u.role = 'guest'
    
ORDER BY b.created_at DESC, b.booking_id ASC;

-- =============================================================================
-- OPTIMIZED QUERY (After Analysis)
-- =============================================================================

-- Optimization Strategy:
-- 1. Remove EXPLAIN to get actual query performance
-- 2. Reduce unnecessary columns to improve index utilization
-- 3. Restructure JOINs for better index usage
-- 4. Add specific WHERE clause to enable index usage
-- 5. Optimize ORDER BY with proper indexing

-- Optimized Query Version 1: Essential Data Only
EXPLAIN
SELECT 
    -- Core booking information
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- Essential user information (guest)
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    u.email AS guest_email,
    
    -- Essential property information
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Essential host information
    CONCAT(h.first_name, ' ', h.last_name) AS host_name,
    h.email AS host_email,
    
    -- Payment information (if exists)
    py.amount AS payment_amount,
    py.payment_method
    
FROM Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment py ON b.booking_id = py.booking_id
    
-- Add index-friendly ORDER BY
ORDER BY b.booking_id DESC;

-- Optimized Query Version 2: With Filtering (Most Efficient)
-- This version adds a WHERE clause to enable better index usage
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    p.name AS property_name,
    p.location,
    py.payment_method
    
FROM Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    LEFT JOIN Payment py ON b.booking_id = py.booking_id
    
-- Add WHERE clause to enable index usage with AND conditions
WHERE b.status IN ('confirmed', 'pending')
    AND b.start_date >= '2025-07-01'
    AND p.pricepernight BETWEEN 100 AND 500
ORDER BY b.booking_id DESC;

-- Optimized Query Version 3: Separate Queries Approach
-- Break the complex query into smaller, focused queries for maximum performance

-- Query 3a: Get booking and guest information
EXPLAIN
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.total_price,
    u.first_name AS guest_first_name,
    u.last_name AS guest_last_name,
    u.email AS guest_email
FROM Booking b
    INNER JOIN User u ON b.user_id = u.user_id
WHERE b.status = 'confirmed' 
    AND b.start_date >= '2025-07-01'
ORDER BY b.booking_id DESC;

-- Query 3b: Get property and host information for specific bookings
EXPLAIN
SELECT 
    b.booking_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    h.first_name AS host_first_name,
    h.last_name AS host_last_name,
    h.email AS host_email
FROM Booking b
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
WHERE b.booking_id IN ('book-001', 'book-002')
    AND p.pricepernight >= 100;

-- Query 3c: Get payment information for specific bookings
EXPLAIN
SELECT 
    py.booking_id,
    py.amount,
    py.payment_method,
    py.payment_date
FROM Payment py
WHERE py.booking_id IN ('book-001', 'book-002')
    AND py.amount >= 100;

