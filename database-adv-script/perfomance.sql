-- =============================================================================
-- AIRBNB DATABASE - QUERY PERFORMANCE OPTIMIZATION
-- =============================================================================

-- Task 1: Initial complex query retrieving bookings with user, property, and payment details
-- This query demonstrates a complex multi-table JOIN that may need optimization

-- Initial Query (Before Optimization)
-- This query retrieves comprehensive booking information including all related details
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
    
-- Order by booking creation date (most recent first)
ORDER BY b.created_at DESC, b.booking_id ASC;