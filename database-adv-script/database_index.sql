-- =============================================================================
-- AIRBNB DATABASE - INDEX CREATION FOR PERFORMANCE OPTIMIZATION
-- =============================================================================

-- Task 2: CREATE INDEX commands for high-usage columns
-- These indexes are designed to optimize query performance based on usage patterns

-- =========================================
-- USER TABLE INDEXES
-- =========================================

-- Index on email column for login and user lookup queries
CREATE INDEX idx_user_email ON User(email);

-- Index on role column for filtering users by type
CREATE INDEX idx_user_role ON User(role);

-- Index on created_at for sorting users by registration date
CREATE INDEX idx_user_created_at ON User(created_at);

-- =========================================
-- PROPERTY TABLE INDEXES
-- =========================================

-- Index on host_id for finding properties by host (foreign key optimization)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for property search by location
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for price range filtering
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Index on created_at for sorting properties by listing date
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for location and price searches (common query pattern)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- =========================================
-- BOOKING TABLE INDEXES
-- =========================================

-- Index on user_id for finding bookings by user (foreign key optimization)
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on property_id for finding bookings by property (foreign key optimization)
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on status for filtering bookings by status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on start_date for date range queries
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date for date range queries
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Index on created_at for sorting bookings chronologically
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Composite index for date range availability checks
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Composite index for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- =========================================
-- REVIEW TABLE INDEXES
-- =========================================

-- Index on property_id for finding reviews by property (foreign key optimization)
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id for finding reviews by user (foreign key optimization)
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating for filtering and aggregating ratings
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at for sorting reviews by date
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property ratings (common aggregation query)
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- =========================================
-- PAYMENT TABLE INDEXES
-- =========================================

-- Index on booking_id for finding payments by booking (foreign key optimization)
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_method for filtering payments by method
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Index on payment_date for date-based queries and reporting
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- =========================================
-- MESSAGE TABLE INDEXES
-- =========================================

-- Index on sender_id for finding messages by sender (foreign key optimization)
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id for finding messages by recipient (foreign key optimization)
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Index on sent_at for sorting messages chronologically
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- =========================================
-- PERFORMANCE MEASUREMENT - BEFORE INDEXING
-- =========================================

-- Test Query 1: User lookup by email (before index)
EXPLAIN ANALYZE
SELECT user_id, first_name, last_name, email, role
FROM User
WHERE email = 'john.doe@example.com';

-- Test Query 2: Property search by location (before index)
EXPLAIN ANALYZE
SELECT property_id, name, location, pricepernight
FROM Property
WHERE location LIKE 'New York%';

-- Test Query 3: Booking lookup by user (before index)
EXPLAIN ANALYZE
SELECT booking_id, start_date, end_date, total_price, status
FROM Booking
WHERE user_id = 'user-123-456';

-- Test Query 4: Property availability check (before index)
EXPLAIN ANALYZE
SELECT property_id, start_date, end_date
FROM Booking
WHERE property_id = 'prop-123-456'
AND start_date BETWEEN '2025-07-01' AND '2025-07-31';

-- Test Query 5: Review aggregation by property (before index)
EXPLAIN ANALYZE
SELECT property_id, AVG(rating) as avg_rating, COUNT(*) as review_count
FROM Review
WHERE property_id = 'prop-123-456'
GROUP BY property_id;

-- =========================================
-- INDEX CREATION COMMANDS
-- =========================================

-- =============================================================================
-- AIRBNB DATABASE - INDEX CREATION FOR PERFORMANCE OPTIMIZATION
-- =============================================================================

-- Task 2: CREATE INDEX commands for high-usage columns
-- These indexes are designed to optimize query performance based on usage patterns

-- =========================================
-- USER TABLE INDEXES
-- =========================================

-- Index on email column for login and user lookup queries
CREATE INDEX idx_user_email ON User(email);

-- Index on role column for filtering users by type
CREATE INDEX idx_user_role ON User(role);

-- Index on created_at for sorting users by registration date
CREATE INDEX idx_user_created_at ON User(created_at);

-- =========================================
-- PROPERTY TABLE INDEXES
-- =========================================

-- Index on host_id for finding properties by host (foreign key optimization)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for property search by location
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for price range filtering
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Index on created_at for sorting properties by listing date
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for location and price searches (common query pattern)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- =========================================
-- BOOKING TABLE INDEXES
-- =========================================

-- Index on user_id for finding bookings by user (foreign key optimization)
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on property_id for finding bookings by property (foreign key optimization)
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on status for filtering bookings by status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on start_date for date range queries
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date for date range queries
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Index on created_at for sorting bookings chronologically
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Composite index for date range availability checks
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Composite index for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- =========================================
-- REVIEW TABLE INDEXES
-- =========================================

-- Index on property_id for finding reviews by property (foreign key optimization)
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id for finding reviews by user (foreign key optimization)
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating for filtering and aggregating ratings
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at for sorting reviews by date
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property ratings (common aggregation query)
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- =========================================
-- PAYMENT TABLE INDEXES
-- =========================================

-- Index on booking_id for finding payments by booking (foreign key optimization)
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_method for filtering payments by method
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Index on payment_date for date-based queries and reporting
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- =========================================
-- MESSAGE TABLE INDEXES
-- =========================================

-- Index on sender_id for finding messages by sender (foreign key optimization)
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id for finding messages by recipient (foreign key optimization)
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Index on sent_at for sorting messages chronologically
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- =========================================
-- PERFORMANCE MEASUREMENT - BEFORE INDEXING
-- =========================================

-- Test Query 1: User lookup by email (before index)
EXPLAIN ANALYZE
SELECT user_id, first_name, last_name, email, role
FROM User
WHERE email = 'john.doe@example.com';

-- Test Query 2: Property search by location (before index)
EXPLAIN ANALYZE
SELECT property_id, name, location, pricepernight
FROM Property
WHERE location LIKE 'New York%';

-- Test Query 3: Booking lookup by user (before index)
EXPLAIN ANALYZE
SELECT booking_id, start_date, end_date, total_price, status
FROM Booking
WHERE user_id = 'user-123-456';

-- Test Query 4: Property availability check (before index)
EXPLAIN ANALYZE
SELECT property_id, start_date, end_date
FROM Booking
WHERE property_id = 'prop-123-456'
AND start_date BETWEEN '2025-07-01' AND '2025-07-31';

-- Test Query 5: Review aggregation by property (before index)
EXPLAIN ANALYZE
SELECT property_id, AVG(rating) as avg_rating, COUNT(*) as review_count
FROM Review
WHERE property_id = 'prop-123-456'
GROUP BY property_id;

-- =========================================
-- INDEX CREATION COMMANDS
-- =========================================

-- =============================================================================
-- AIRBNB DATABASE - INDEX CREATION FOR PERFORMANCE OPTIMIZATION
-- =============================================================================

-- Task 2: CREATE INDEX commands for high-usage columns
-- These indexes are designed to optimize query performance based on usage patterns

-- =========================================
-- USER TABLE INDEXES
-- =========================================

-- Index on email column for login and user lookup queries
CREATE INDEX idx_user_email ON User(email);

-- Index on role column for filtering users by type
CREATE INDEX idx_user_role ON User(role);

-- Index on created_at for sorting users by registration date
CREATE INDEX idx_user_created_at ON User(created_at);

-- =========================================
-- PROPERTY TABLE INDEXES
-- =========================================

-- Index on host_id for finding properties by host (foreign key optimization)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for property search by location
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for price range filtering
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Index on created_at for sorting properties by listing date
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for location and price searches (common query pattern)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- =========================================
-- BOOKING TABLE INDEXES
-- =========================================

-- Index on user_id for finding bookings by user (foreign key optimization)
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on property_id for finding bookings by property (foreign key optimization)
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on status for filtering bookings by status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on start_date for date range queries
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date for date range queries
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Index on created_at for sorting bookings chronologically
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Composite index for date range availability checks
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Composite index for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- =========================================
-- REVIEW TABLE INDEXES
-- =========================================

-- Index on property_id for finding reviews by property (foreign key optimization)
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id for finding reviews by user (foreign key optimization)
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating for filtering and aggregating ratings
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at for sorting reviews by date
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property ratings (common aggregation query)
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- =========================================
-- PAYMENT TABLE INDEXES
-- =========================================

-- Index on booking_id for finding payments by booking (foreign key optimization)
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_method for filtering payments by method
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Index on payment_date for date-based queries and reporting
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- =========================================
-- MESSAGE TABLE INDEXES
-- =========================================

-- Index on sender_id for finding messages by sender (foreign key optimization)
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id for finding messages by recipient (foreign key optimization)
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Index on sent_at for sorting messages chronologically
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- =========================================
-- PERFORMANCE MEASUREMENT - BEFORE INDEXING
-- =========================================

-- Test Query 1: User lookup by email (before index)
EXPLAIN ANALYZE
SELECT user_id, first_name, last_name, email, role
FROM User
WHERE email = 'john.doe@example.com';

-- Test Query 2: Property search by location (before index)
EXPLAIN ANALYZE
SELECT property_id, name, location, pricepernight
FROM Property
WHERE location LIKE 'New York%';

-- Test Query 3: Booking lookup by user (before index)
EXPLAIN ANALYZE
SELECT booking_id, start_date, end_date, total_price, status
FROM Booking
WHERE user_id = 'user-123-456';

-- Test Query 4: Property availability check (before index)
EXPLAIN ANALYZE
SELECT property_id, start_date, end_date
FROM Booking
WHERE property_id = 'prop-123-456'
AND start_date BETWEEN '2025-07-01' AND '2025-07-31';

-- Test Query 5: Review aggregation by property (before index)
EXPLAIN ANALYZE
SELECT property_id, AVG(rating) as avg_rating, COUNT(*) as review_count
FROM Review
WHERE property_id = 'prop-123-456'
GROUP BY property_id;

-- =========================================
-- INDEX CREATION COMMANDS
-- =========================================

-- =============================================================================
-- AIRBNB DATABASE - INDEX CREATION FOR PERFORMANCE OPTIMIZATION
-- =============================================================================

-- Task 2: CREATE INDEX commands for high-usage columns
-- These indexes are designed to optimize query performance based on usage patterns

-- =========================================
-- USER TABLE INDEXES
-- =========================================

-- Index on email column for login and user lookup queries
CREATE INDEX idx_user_email ON User(email);

-- Index on role column for filtering users by type
CREATE INDEX idx_user_role ON User(role);

-- Index on created_at for sorting users by registration date
CREATE INDEX idx_user_created_at ON User(created_at);

-- =========================================
-- PROPERTY TABLE INDEXES
-- =========================================

-- Index on host_id for finding properties by host (foreign key optimization)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for property search by location
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for price range filtering
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Index on created_at for sorting properties by listing date
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for location and price searches (common query pattern)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- =========================================
-- BOOKING TABLE INDEXES
-- =========================================

-- Index on user_id for finding bookings by user (foreign key optimization)
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on property_id for finding bookings by property (foreign key optimization)
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on status for filtering bookings by status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on start_date for date range queries
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date for date range queries
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Index on created_at for sorting bookings chronologically
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Composite index for date range availability checks
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);

-- Composite index for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- =========================================
-- REVIEW TABLE INDEXES
-- =========================================

-- Index on property_id for finding reviews by property (foreign key optimization)
CREATE INDEX idx_review_property_id ON Review(property_id);

-- Index on user_id for finding reviews by user (foreign key optimization)
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Index on rating for filtering and aggregating ratings
CREATE INDEX idx_review_rating ON Review(rating);

-- Index on created_at for sorting reviews by date
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property ratings (common aggregation query)
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- =========================================
-- PAYMENT TABLE INDEXES
-- =========================================

-- Index on booking_id for finding payments by booking (foreign key optimization)
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Index on payment_method for filtering payments by method
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Index on payment_date for date-based queries and reporting
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- =========================================
-- MESSAGE TABLE INDEXES
-- =========================================

-- Index on sender_id for finding messages by sender (foreign key optimization)
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Index on recipient_id for finding messages by recipient (foreign key optimization)
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Index on sent_at for sorting messages chronologically
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation queries
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- =========================================
-- PERFORMANCE MEASUREMENT - AFTER INDEXING
-- =========================================

-- Test Query 1: User lookup by email (after index)
EXPLAIN ANALYZE
SELECT user_id, first_name, last_name, email, role
FROM User
WHERE email = 'john.doe@example.com';

-- Test Query 2: Property search by location (after index)
EXPLAIN ANALYZE
SELECT property_id, name, location, pricepernight
FROM Property
WHERE location LIKE 'New York%';

-- Test Query 3: Booking lookup by user (after index)
EXPLAIN ANALYZE
SELECT booking_id, start_date, end_date, total_price, status
FROM Booking
WHERE user_id = 'user-123-456';

-- Test Query 4: Property availability check (after index)
EXPLAIN ANALYZE
SELECT property_id, start_date, end_date
FROM Booking
WHERE property_id = 'prop-123-456'
AND start_date BETWEEN '2025-07-01' AND '2025-07-31';

-- Test Query 5: Review aggregation by property (after index)
EXPLAIN ANALYZE
SELECT property_id, AVG(rating) as avg_rating, COUNT(*) as review_count
FROM Review
WHERE property_id = 'prop-123-456'
GROUP BY property_id;

-- =========================================
-- COMPOSITE QUERY PERFORMANCE TESTS
-- =========================================

-- Complex query 1: Property search with host information
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.pricepernight,
       u.first_name, u.last_name
FROM Property p
JOIN User u ON p.host_id = u.user_id
WHERE p.location LIKE 'Miami%'
AND p.pricepernight BETWEEN 100 AND 300;

-- Complex query 2: Booking history with property details
EXPLAIN ANALYZE
SELECT b.booking_id, b.start_date, b.end_date, b.total_price,
       p.name, p.location
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = 'user-123-456'
ORDER BY b.start_date DESC;

-- Complex query 3: Property ratings summary
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location,
       AVG(r.rating) as avg_rating,
       COUNT(r.review_id) as review_count
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location LIKE 'California%'
GROUP BY p.property_id, p.name, p.location
HAVING COUNT(r.review_id) > 0
ORDER BY avg_rating DESC;

-- =========================================
-- INDEX USAGE VERIFICATION
-- =========================================

-- Check if indexes are being used
EXPLAIN
SELECT * FROM User WHERE email = 'test@example.com';

EXPLAIN
SELECT * FROM Property WHERE location = 'New York';

EXPLAIN
SELECT * FROM Booking WHERE user_id = 'user-123';

EXPLAIN
SELECT * FROM Review WHERE property_id = 'prop-123';

-- =========================================
-- PERFORMANCE COMPARISON SUMMARY
-- =========================================

/*
EXPECTED PERFORMANCE IMPROVEMENTS:

1. User Email Lookup:
   - Before: Full table scan (Type: ALL)
   - After: Index range scan (Type: ref)
   - Expected improvement: 90%+ faster

2. Property Location Search:
   - Before: Full table scan with filesort
   - After: Index scan with optimized filtering
   - Expected improvement: 80%+ faster

3. Booking User Lookup:
   - Before: Full table scan
   - After: Index range scan
   - Expected improvement: 85%+ faster

4. Date Range Queries:
   - Before: Full table scan with temporary table
   - After: Index range scan
   - Expected improvement: 75%+ faster

5. JOIN Operations:
   - Before: Nested loop with full scans
   - After: Index nested loop joins
   - Expected improvement: 70%+ faster
*/
