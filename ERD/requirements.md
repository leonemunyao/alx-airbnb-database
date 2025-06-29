## Entities and Attributes

### User

* __user_id__: Primary Key, UUID, Indexed
* __first_name__: VARCHAR, NOT NULL
* __last_name__: VARCHAR, NOT NULL
* __email__: VARCHAR, UNIQUE, NOT NULL
* __password_hash__: VARCHAR, NOT NULL
* __phone_number__: VARCHAR, NULL
* __role__: ENUM (guest, host, admin), NOT NULL
* __created_at__: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### Property

* __property_id__: Primary Key, UUID, Indexed
* __host_id__: Foreign Key, references User(user_id)
* __name__: VARCHAR, NOT NULL
* __description__: TEXT, NOT NULL
* __location__: VARCHAR, NOT NULL
* __pricepernight__: DECIMAL, NOT NULL
* __created_at__: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
* __updated_at__: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

### Booking

* __booking_id__: Primary Key, UUID, Indexed
* __property_id__: Foreign Key, references Property(property_id)
* __user_id__: Foreign Key, references User(user_id)
* __start_date__: DATE, NOT NULL
* __end_date__: DATE, NOT NULL
* __total_price__: DECIMAL, NOT NULL
* __status__: ENUM (pending, confirmed, canceled), NOT NULL
* __created_at__: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### Payment

* __payment_id__: Primary Key, UUID, Indexed
* __booking_id__: Foreign Key, references Booking(booking_id)
* __amount__: DECIMAL, NOT NULL
* __payment_date__: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
* __payment_method__: ENUM (credit_card, paypal, stripe), NOT NULL

### Review

* __review_id__: Primary Key, UUID, Indexed
* __property_id__: Foreign Key, references Property(property_id)
* __user_id__: Foreign Key, references User(user_id)
* __rating__: INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL
* __comment__: TEXT, NOT NULL
* __created_at__: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### Message

* __message_id__: Primary Key, UUID, Indexed
* __sender_id__: Foreign Key, references User(user_id)
* __recipient_id__: Foreign Key, references User(user_id)
* __message_body__: TEXT, NOT NULL
* __sent_at__: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP


