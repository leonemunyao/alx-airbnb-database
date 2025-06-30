## Database Normalization to 3NF for AirBnB Clone

__Normalization__ is the process of structuring a relational database to reduce redundancy and improve data integrity.

* In __1NF__ we eliminate repeating groups.
* In __2NF__ we ensure full functional dependancy of non-key attributes on the entire primary key.
* In __3NF__ we ensure transitive dependancy is eliminated: non key attributes should depend only on the primary key.

---

## Step by Step Normalization

###  🔹 Step 1: **Unnormalized Form (UNF)**

This is the initial design where

* Some fields may contain mulrivalued and compoisite data.
* No structure to eliminate redundacy.

---

### 🔹 Step 2: **First Normal Form (1NF)**

**Goal:** Ensure each field contains only atomic values and each record is unique.

**The schema already satisfies 1NF** since:

* All attributes are atomic for example `email`.
* Every table in the database has a primary key eg `user_id`.
* No repeating groups.

---

### 🔹 Step 3: **Second Normal Form (2NF)**

**Goal:** Eliminate partial dependancies. All non-key attributes must depend on the entire primary key.

Applies primarily on tables with __composite primary keys__
The schema uses **surrogate primary keys(UUIDs)** in every table thus each non-key attribute depends fully on the single primary key.
* Therefore all the tables are in __2NF__.

### 🔹 Step 4: **Third Normal Form (3NF)**

**Goal** Non-key attributes should not depend on other non-key attributes.

### `User` Table

All fields depend directly on `user_id`.  
Therfore its already in 3NF.

### `Property` Table

All attributes depend on `property_id`.  
Therefore its already in 3NF.

### `Booking` Table

All attributes depend on `booking_id`.  
Already in 3NF.

### `Payment` Table

All attributes depend on `payment_id`.  
Already in 3NF.

### `Review` Table

All attributes depend on `review_id`.  
Already in 3NF.

### `Message` Table

All attributes depend on `message_id`.  
Already in 3NF.

---

---

## Summary of Normalization Results

| Table     | 1NF | 2NF | 3NF | Remarks |
|-----------|-----|-----|-----|---------|
| User      | ✅  | ✅  | ✅  | All fields atomic and depend on `user_id` |
| Property  | ✅  | ✅  | ✅  | Clean separation of host info via FK |
| Booking   | ✅  | ✅  | ✅  | Clear separation of user and property |
| Payment   | ✅  | ✅  | ✅  | Linked strictly to a booking |
| Review    | ✅  | ✅  | ✅  | No derived/transitive data |
| Message   | ✅  | ✅  | ✅  | Simple design, direct dependencies |

---

