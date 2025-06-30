# Seed Data Documentation

This document provides a comprehensive explanation of the sample data inserted into the Airbnb database through the `seed.sql` file. The seed data creates a realistic scenario with users, properties, bookings, payments, reviews, and messages to demonstrate the database functionality.

## Overview

The seed data populates six main tables with interconnected sample records that simulate real-world usage of an Airbnb-like platform. The data includes three users with different roles, two properties, bookings, payments, reviews, and messages between users.

## Table Data Breakdown

### 🔐 User Table

The User table contains three sample users representing different roles in the system:

| Field | User 1 | User 2 | User 3 |
|-------|--------|--------|--------|
| **user_id** | uuid-001 | uuid-002 | uuid-003 |
| **first_name** | Gabriel | Jude | Daniel |
| **last_name** | Batistuta | Bellingham | Van Buyten |
| **email** | batistuta@example.com | bellingham@example.com | buyten@example.com |
| **password_hash** | hash1 | hash2 | hash3 |
| **phone_number** | 1234567890 | 0987654321 | NULL |
| **role** | guest | host | admin |
| **created_at** | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP |

**Key Points:**
- **Gabriel Batistuta** (`uuid-001`) is a **guest** who books properties
- **Jude Bellingham** (`uuid-002`) is a **host** who owns properties
- **Daniel Van Buyten** (`uuid-003`) is an **admin** with no phone number
- All users are created with the current timestamp
- Password hashes are simplified for demonstration purposes

### 🏠 Property Table

Two luxury properties are listed, both owned by the same host:

| Field | Property 1 | Property 2 |
|-------|------------|------------|
| **property_id** | prop-001 | prop-002 |
| **host_id** | uuid-002 (Jude Bellingham) | uuid-002 (Jude Bellingham) |
| **name** | Sarova Whitesands Beach Resort | Jumeirah Beach Hotel |
| **description** | A beautiful 4 star hotel near the beach | The greatest 5 star hotel in Mombasa |
| **location** | Mombasa, Kenya | Mombasa, Kenya |
| **pricepernight** | 75,000.00 KES | 120,000.00 KES |
| **created_at** | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP |
| **updated_at** | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP |

**Key Points:**
- Both properties are located in **Mombasa, Kenya**
- **Sarova Whitesands** is a 4-star property at 75,000 KES per night
- **Jumeirah Beach Hotel** is a premium 5-star property at 120,000 KES per night
- Both properties are owned by Jude Bellingham (the host)
- Prices reflect luxury accommodations in Kenyan Shillings

### 📅 Booking Table

Two bookings are made by the same guest for different properties:

| Field | Booking 1 | Booking 2 |
|-------|-----------|-----------|
| **booking_id** | book-001 | book-002 |
| **property_id** | prop-001 (Sarova Whitesands) | prop-002 (Jumeirah Beach Hotel) |
| **user_id** | uuid-001 (Gabriel Batistuta) | uuid-001 (Gabriel Batistuta) |
| **start_date** | 2025-07-10 | 2025-08-01 |
| **end_date** | 2025-07-15 | 2025-08-05 |
| **total_price** | 320,000.00 KES | 360,000.00 KES |
| **status** | confirmed | pending |
| **created_at** | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP |

**Key Points:**
- **Gabriel Batistuta** books both properties for different periods
- **First booking**: 5 nights at Sarova Whitesands (July 10-15, 2025) - **CONFIRMED**
- **Second booking**: 4 nights at Jumeirah Beach Hotel (August 1-5, 2025) - **PENDING**
- Total prices reflect: (nights × price_per_night) + potential fees
- Different booking statuses demonstrate various stages of the booking process

### 💳 Payment Table

Payment records correspond to both bookings:

| Field | Payment 1 | Payment 2 |
|-------|-----------|-----------|
| **payment_id** | pay-001 | pay-002 |
| **booking_id** | book-001 | book-002 |
| **amount** | 320,000.00 KES | 360,000.00 KES |
| **payment_date** | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP |
| **payment_method** | credit_card | mpesa |

**Key Points:**
- Payment amounts **exactly match** the booking total prices
- **First payment**: Credit card payment for the confirmed Sarova booking
- **Second payment**: M-Pesa payment (popular mobile payment in Kenya) for the Jumeirah booking
- Both payments are processed at the current timestamp
- Demonstrates different payment methods available in the system

### 🌟 Review Table

Two reviews are left by the guest for both properties:

| Field | Review 1 | Review 2 |
|-------|----------|----------|
| **review_id** | rev-001 | rev-002 |
| **property_id** | prop-001 (Sarova Whitesands) | prop-002 (Jumeirah Beach Hotel) |
| **user_id** | uuid-001 (Gabriel Batistuta) | uuid-001 (Gabriel Batistuta) |
| **rating** | 5 | 4 |
| **comment** | "Amazing stay, great view! Nice meals and service" | "Lovely place, would wish to come back once more." |
| **created_at** | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP |

**Key Points:**
- **Gabriel** reviews both properties after his stays
- **Sarova Whitesands** receives a perfect **5-star rating** with praise for views, meals, and service
- **Jumeirah Beach Hotel** receives a **4-star rating** with positive feedback and intent to return
- Reviews provide valuable feedback for future guests and property improvement

### 💬 Message Table

A conversation between the guest and host regarding availability:

| Field | Message 1 | Message 2 |
|-------|-----------|-----------|
| **message_id** | msg-001 | msg-002 |
| **sender_id** | uuid-001 (Gabriel Batistuta) | uuid-002 (Jude Bellingham) |
| **recipient_id** | uuid-002 (Jude Bellingham) | uuid-001 (Gabriel Batistuta) |
| **message_body** | "Hi, is the Sarova Whitesands Beach Resort available for next weekend?" | "Yes, it is available from Friday." |
| **sent_at** | CURRENT_TIMESTAMP | CURRENT_TIMESTAMP |

**Key Points:**
- **Gabriel** (guest) initiates contact with **Jude** (host) about property availability
- **Jude** responds positively about availability
- Demonstrates the messaging system facilitating communication between users
- Messages are timestamped for proper conversation tracking

## Data Relationships

The seed data demonstrates key relationships in the database:

1. **User-Property Relationship**: Jude (host) owns both properties
2. **User-Booking Relationship**: Gabriel (guest) makes both bookings
3. **Property-Booking Relationship**: Each property has associated bookings
4. **Booking-Payment Relationship**: Each booking has a corresponding payment
5. **Property-Review Relationship**: Both properties have reviews from the guest
6. **User-Message Relationship**: Users communicate through the messaging system

## Business Logic Demonstrated

The seed data showcases several important business scenarios:

- **Multi-property hosts**: One host managing multiple properties
- **Repeat customers**: One guest booking multiple properties
- **Different booking statuses**: Confirmed vs. pending bookings
- **Multiple payment methods**: Credit card and mobile payments
- **Review system**: Guest feedback on properties
- **Communication**: Host-guest messaging for inquiries

## Data Integrity Notes

- All foreign key relationships are properly maintained
- Monetary amounts are consistent between bookings and payments
- Timestamps use `CURRENT_TIMESTAMP` for realistic date/time values
- User roles are diverse (guest, host, admin) for comprehensive testing
- Phone numbers include NULL values to test optional field handling

This seed data provides a solid foundation for testing the Airbnb database system with realistic, interconnected records that demonstrate the platform's core functionality.
