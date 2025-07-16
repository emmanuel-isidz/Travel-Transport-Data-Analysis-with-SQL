# 🚗 Travel & Transport Data Analysis with SQL

This project explores and analyzes travel and transportation data using **SQL**. The goal is to derive actionable insights such as revenue performance, trip patterns, booking behavior, and route usage from raw data containing trip, customer, and vehicle information.

---

## 📊 Project Overview

The dataset contains three main tables:

- `trip_data`: Records of individual trips (status, price, vehicle type, dates, routes, etc.)
- `customer_data`: Customer details (name, city, gender, etc.)
- `vehicle_data`: Information about vehicle types (if normalized)

Using MySQL queries, this project provides insights on:

- Total bookings and revenue per vehicle type and trip status
- Most frequently used travel routes
- Monthly trend of trip statuses (Completed, Cancelled, Pending)
- Average days between booking and travel
- Trip counts by customer and city
- Gender-based average spending per trip

---

## 🧪 Key SQL Queries

### ✅ Summary Report: Revenue & Bookings by Vehicle Type & Status
```sql
SELECT 
    vehicle_type,
    status,
    COUNT(trip_id) AS total_bookings,
    ROUND(SUM(price), 2) AS total_revenue
FROM trip_data
GROUP BY vehicle_type, status
ORDER BY vehicle_type, status;
```
### 🗺️ Most Frequently Used Routes
```sql

SELECT origin, destination, COUNT(*) AS trip_count
FROM trip_data
GROUP BY origin, destination
ORDER BY trip_count DESC
LIMIT 1;
```
📅 Monthly Breakdown of Trip Statuses
```sql
SELECT 
    DATE_FORMAT(travel_date, '%Y-%m') AS trip_month,
    status,
    COUNT(*) AS trip_count
FROM trip_data
GROUP BY trip_month, status
ORDER BY trip_month, status;
```
👤 Gender-wise Average Spending
```sql
SELECT 
    c.gender,
    ROUND(AVG(t.price), 2) AS avg_spend_per_trip
FROM customer_data AS c
JOIN trip_data AS t ON c.customer_id = t.customer_id
WHERE t.status = 'Completed'
GROUP BY c.gender
ORDER BY avg_spend_per_trip DESC;
```
📍 Trip Count by City for Cancelled Trips
```sql
SELECT c.city, COUNT(t.trip_id) AS trips
FROM customer_data AS c
JOIN trip_data AS t ON c.customer_id = t.customer_id
WHERE t.status = 'Cancelled'
GROUP BY c.city
ORDER BY trips DESC;
