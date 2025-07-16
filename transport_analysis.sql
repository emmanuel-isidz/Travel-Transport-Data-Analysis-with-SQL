create database transport;

use transport;
select * from customer_data;

select * from trip_data;

select * from vehicle_data;

describe customer_data;
describe trip_data;
describe vehicle_data;

-- convert from text to date format
update customer_data
set signup_date = str_to_date(signup_date,'%Y-%m-%d');
alter table customer_data
modify column signup_date date;

update trip_data
set booking_date = str_to_date(booking_date,'%Y-%m-%d'),
travel_date = str_to_date(travel_date,'%Y-%m-%d');

alter table trip_data
modify column booking_date date,
modify column travel_date date;

-- List the top 10 most expensive completed trips and their destinations.
select destination,max(price),status
from trip_data
where status="Completed"
group by destination
order by max(price) desc
limit 10;

select destination,origin,price,status
from trip_data
where status="Completed"
order by price desc
limit 10;

--  How many trips were booked from each origin city?
select distinct origin,count(customer_id) as bookings
from trip_data
group by origin;

-- Find the total revenue generated from completed trips.
select round(sum(price),2) as revenue,status
from trip_data
where status="Completed";

-- Show the average trip price per vehicle type.
select round(avg(price),2) as average_price,vehicle_type
from trip_data
group by vehicle_type;

-- Which customer has booked the highest number of completed trips?
select c.full_name,count(t.trip_id),t.status
from customer_data as c
join trip_data as t on c.customer_id=t.customer_id
where t.status="Completed"
group by c.full_name
order by count(t.trip_id) desc
limit 1;

-- List all customers who booked more than 3 trips.
select c.full_name,count(t.trip_id) as total_trips
from customer_data as c
join trip_data as t on c.customer_id=t.customer_id
group by c.full_name
having count(t.trip_id) > 3
order by total_trips desc;

-- Show the number of trips that were cancelled per city.
select c.city,count(t.trip_id) as trips,status
from customer_data as c
join trip_data as t on c.customer_id=t.customer_id
where status="Cancelled"
group by c.city;

-- Find the most frequently used travel route (origin to destination).
select origin,destination,count(trip_id) as trips
from trip_data
group by origin,destination
order by count(trip_id) desc
limit 1;

-- Calculate the average number of days between booking and travel for all completed trips.
select status, avg(datediff(booking_date,travel_date)) as avg_days
from trip_data
where status = "Completed";

SELECT status, AVG(DATEDIFF(travel_date, booking_date)) AS avg_days
FROM trip_data
WHERE status = 'Completed';

--  Show a breakdown of completed vs cancelled vs pending trips by month.
select count(trip_id) as trips, status
from trip_data
group by status;


SELECT 
    month(travel_date) AS trip_month,
    status,
    COUNT(trip_id) AS trip_count
FROM trip_data
GROUP BY trip_month, status
order by trip_month;

-- Determine which gender spends more on average per trip.

SELECT 
    c.gender,
    ROUND(AVG(t.price), 2) AS avg_spend_per_trip
FROM customer_data AS c
JOIN trip_data AS t ON c.customer_id = t.customer_id
WHERE t.status = 'Completed'  -- Optional: only consider completed trips
GROUP BY c.gender
ORDER BY avg_spend_per_trip DESC;

-- List all customers who have never completed a trip.
select c.full_name,t.status
FROM customer_data AS c
JOIN trip_data AS t ON c.customer_id = t.customer_id
where t.status <> "Completed";

-- What is the total number of trips and average price per customer city?
select count(t.trip_id) as trips,round(avg(t.price)) as avg_price,c.city
FROM customer_data AS c
JOIN trip_data AS t ON c.customer_id = t.customer_id
group by c.city;

-- Identify which vehicle type has the highest cancellation rate
select v.vehicle_type,count(*) as number_of_cancelled,t.status
FROM vehicle_data AS v
JOIN trip_data AS t ON v.vehicle_type = t.vehicle_type
where t.status = "Cancelled"
group by v.vehicle_type
order by number_of_cancelled desc
limit 1;

-- Create a summary report showing total bookings and revenue per vehicle type and status
SELECT 
    vehicle_type,
    status,
    COUNT(trip_id) AS total_bookings,
    ROUND(SUM(price), 2) AS total_revenue
FROM trip_data
GROUP BY vehicle_type, status
ORDER BY vehicle_type, status;



