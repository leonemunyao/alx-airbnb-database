
-- 🔐 User Table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('uuid-001', 'Gabriel', 'Batistuta', 'batistuta@example.com', 'hash1', '1234567890', 'guest', CURRENT_TIMESTAMP),
('uuid-002', 'Jude', 'Bellingham', 'bellingham@example.com', 'hash2', '0987654321', 'host', CURRENT_TIMESTAMP),
('uuid-003', 'Daniel', 'Van Buyten', 'buyten@example.com', 'hash3', NULL, 'admin', CURRENT_TIMESTAMP);

-- 🏠 Property Table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
('prop-001', 'uuid-002', 'Sarova Whitesands Beach Resort', 'A beautiful 4 star hotel near the beach', 'Mombasa, Kenya', 75000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('prop-002', 'uuid-002', 'Jumeirah Beach Hotel', 'The greatest 5 star hotel in Mombasa', 'Mombasa, Kenya', 120000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 📅 Booking Table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
('book-001', 'prop-001', 'uuid-001', '2025-07-10', '2025-07-15', 320000.00, 'confirmed', CURRENT_TIMESTAMP),
('book-002', 'prop-002', 'uuid-001', '2025-08-01', '2025-08-05', 360000.00, 'pending', CURRENT_TIMESTAMP);

-- 💳 Payment Table
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
('pay-001', 'book-001', 320000.00, CURRENT_TIMESTAMP, 'credit_card'),
('pay-002', 'book-002', 360000.00, CURRENT_TIMESTAMP, 'mpesa');

-- 🌟 Review Table
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('rev-001', 'prop-001', 'uuid-001', 5, 'Amazing stay, great view! Nice meals and service', CURRENT_TIMESTAMP),
('rev-002', 'prop-002', 'uuid-001', 4, 'Lovely place, would wish to come back once more.', CURRENT_TIMESTAMP);

-- 💬 Message Table
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
('msg-001', 'uuid-001', 'uuid-002', 'Hi, is the Sarova Whitesands Beach Resort available for next weekend?', CURRENT_TIMESTAMP),
('msg-002', 'uuid-002', 'uuid-001', 'Yes, it is available from Friday.', CURRENT_TIMESTAMP);

