-- =============================================================================
-- AIRBNB DATABASE - SUBQUERIES
-- =============================================================================

-- Task 1: Non-correlated subquery to find properties with average rating > 4.0
-- This query uses a subquery to calculate average ratings and filter properties

SELECT 
    p.property_id,
    p.name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);

-- Task 2: Correlated subquery to find users who have made more than 3 bookings
-- This query uses a correlated subquery that references the outer query

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    u.created_at
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;

