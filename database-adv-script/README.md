# Database Advanced Script - Join Queries

This directory contains advanced SQL join queries for the Airbnb database. The `joins_queries.sql` file demonstrates three different types of JOIN operations to retrieve data from multiple related tables.

## Join Queries Overview

### 1. INNER JOIN Query
**Purpose**: Retrieve all bookings with their respective users

- **Tables**: Booking ↔ User
- **Result**: Shows only bookings that have a valid user associated with them
- **Use Case**: Display booking details along with customer information
- **Key Feature**: Excludes orphaned bookings (bookings without users)

### 2. LEFT JOIN Query
**Purpose**: Retrieve all properties and their reviews (including properties with no reviews)

- **Tables**: Property ↔ Review ↔ User
- **Result**: Shows all properties, whether they have reviews or not
- **Use Case**: Property listing with review information, ensuring no properties are excluded
- **Key Feature**: Properties without reviews appear with NULL review values

### 3. FULL OUTER JOIN Query
**Purpose**: Retrieve all users and all bookings (including unmatched records)

- **Tables**: User ↔ Booking
- **Result**: Shows all users and all bookings, regardless of relationships
- **Use Case**: Complete overview of users and bookings, including users who haven't booked and orphaned bookings
- **Key Feature**: Displays users without bookings and bookings without valid users

## Usage

Execute the queries in `joins_queries.sql` against your Airbnb database to see the different join behaviors and results. Each query serves a specific business purpose and demonstrates different approaches to handling related data.
