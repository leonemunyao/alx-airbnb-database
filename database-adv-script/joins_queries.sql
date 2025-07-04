-- =============================================================================
-- AIRBNB DATABASE - ADVANCED JOIN QUERIES
-- =============================================================================

-- Query 1: INNER JOIN to retrieve all bookings and respective users
-- This query joins the Booking table with the User table to get booking details
-- along with the user information for each booking

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;

-- Query 2: LEFT JOIN to retrieve all properties and their reviews
-- This query joins the Property table with the Review table to get all properties
-- including those that have no reviews (LEFT JOIN ensures all properties are shown)

SELECT 
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_created_at,
    u.first_name,
    u.last_name,
    u.email
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
LEFT JOIN User u ON r.user_id = u.user_id
ORDER BY p.created_at DESC, r.created_at DESC;

-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings
-- This query shows all users and all bookings, including users with no bookings
-- and bookings that are not linked to any user (if any exist)

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at
FROM User u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id
ORDER BY u.created_at DESC, b.created_at DESC;

