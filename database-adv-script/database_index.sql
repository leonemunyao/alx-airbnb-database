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
