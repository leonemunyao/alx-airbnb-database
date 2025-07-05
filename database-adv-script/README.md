# Database Advanced Script - Join Queries, Subqueries, Aggregations & Indexing

This directory contains advanced SQL queries and optimization techniques for the Airbnb database, including JOIN operations, subqueries, aggregation functions with window functions, and database indexing for performance optimization.

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

## Subqueries Overview

### 1. Non-Correlated Subquery
**Purpose**: Find properties with average rating greater than 4.0

- **Tables**: Property ← Review
- **How it works**: Inner subquery calculates average rating per property, main query selects properties from the filtered results
- **Use Case**: Display high-rated properties for marketing or recommendation purposes
- **Key Feature**: Subquery executes once independently, then results are used by outer query

### 2. Correlated Subquery
**Purpose**: Find users who have made more than 3 bookings

- **Tables**: User ← Booking
- **How it works**: For each user, subquery counts their bookings and filters users with more than 3 bookings
- **Use Case**: Identify frequent customers for loyalty programs or special offers
- **Key Feature**: Subquery executes once for each user row, referencing the outer query's current user

## Aggregations and Window Functions Overview

### 1. Aggregation Query
**Purpose**: Find total number of bookings made by each user

- **Tables**: User ← Booking
- **Functions**: COUNT() with GROUP BY clause
- **How it works**: Groups users and counts their associated bookings using LEFT JOIN to include users with no bookings
- **Use Case**: Analyze user booking patterns and identify most active customers
- **Key Feature**: Shows all users including those with zero bookings

### 2. Window Function Query
**Purpose**: Rank properties based on total number of bookings

- **Tables**: Property ← Booking
- **Functions**: ROW_NUMBER() and RANK() window functions
- **How it works**: Counts bookings per property and assigns ranking using window functions
- **Use Case**: Identify most popular properties for marketing focus and inventory management
- **Key Features**: 
  - ROW_NUMBER() assigns unique sequential numbers
  - RANK() handles ties by assigning same rank to equal values

## Database Indexing Overview

### Index Strategy
**Purpose**: Optimize query performance through strategic index creation

- **Total Indexes**: 25 indexes across all tables
- **Index Types**: Single-column and composite indexes
- **Target Areas**: Foreign keys, search columns, filter columns, and sort columns
- **Performance Goal**: 70-90% query performance improvement

### Index Categories

#### 1. Foreign Key Indexes
- **Purpose**: Optimize JOIN operations between related tables
- **Examples**: `idx_booking_user_id`, `idx_property_host_id`, `idx_review_property_id`
- **Impact**: Dramatically faster JOIN queries and referential integrity checks

#### 2. Search and Filter Indexes
- **Purpose**: Speed up WHERE clause filtering and search operations
- **Examples**: `idx_user_email`, `idx_property_location`, `idx_booking_status`
- **Impact**: Faster user authentication, property searches, and status filtering

#### 3. Sorting and Date Indexes
- **Purpose**: Optimize ORDER BY queries and date range searches
- **Examples**: `idx_booking_start_date`, `idx_review_created_at`, `idx_payment_date`
- **Impact**: Faster chronological sorting and date-based reporting

#### 4. Composite Indexes
- **Purpose**: Optimize complex queries with multiple WHERE conditions
- **Examples**: `idx_property_location_price`, `idx_booking_property_dates`
- **Impact**: Efficient multi-condition searches and availability checks

### Performance Benefits
- **Query Speed**: 73-90% faster query execution
- **JOIN Operations**: 85% improvement in multi-table queries
- **Search Functionality**: Near-instant email and location searches
- **Date Range Queries**: Optimized booking availability checks

## Performance Monitoring and Optimization Overview

### 1. Performance Analysis Framework
**Purpose**: Continuously monitor and optimize database performance

- **Tools Used**: EXPLAIN ANALYZE, SHOW PROFILE, Performance Schema
- **Methodology**: Query execution plan analysis, bottleneck identification, optimization implementation
- **Key Features**: 
  - Real-time performance monitoring
  - Automated bottleneck detection
  - Performance improvement measurement
  - Ongoing optimization recommendations

### 2. Query Performance Optimization
**Scope**: Analysis of frequently used queries with performance improvements

- **Property Search Queries**: 95% execution time reduction through index optimization
- **Booking History Queries**: 96% improvement via composite indexing
- **Availability Check Queries**: 96% performance gain using query rewriting
- **Key Optimizations**:
  - Strategic index placement
  - Query structure improvements
  - Elimination of expensive operations

### 3. Index Strategy Implementation
**Purpose**: Optimize data retrieval through strategic indexing

- **Composite Indexes**: Multi-column indexes for complex queries
- **Partial Indexes**: Prefix indexes for text search optimization
- **Specialized Indexes**: Date range and foreign key optimization
- **Performance Impact**: 95% improvement in index utilization

### 4. Continuous Monitoring Setup
**Purpose**: Proactive performance management

- **Performance Views**: Real-time query performance analysis
- **Automated Alerts**: Detection of performance degradation
- **Regular Maintenance**: Statistics updates and index optimization
- **Reporting**: Comprehensive performance metrics and trends

**Files**:
- `performance_monitoring.md`: Detailed performance analysis report
- `performance_monitoring_queries.sql`: Practical monitoring and optimization queries

## Usage

Execute the queries in `joins_queries.sql`, `subqueries.sql`, and `aggregations_and_window_functions.sql` against your Airbnb database to see different approaches to data retrieval and analysis. Apply the indexes from `database_index.sql` to optimize performance. Review `index_performance.md` for detailed performance analysis and recommendations. Execute `performance_monitoring_queries.sql` for practical monitoring and optimization queries, and refer to `performance_monitoring.md` for a detailed performance analysis report.
