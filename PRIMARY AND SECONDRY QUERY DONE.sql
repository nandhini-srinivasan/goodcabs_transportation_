use targets_db;
use trips_db;

-- 1 --
select *from dim_city;
select city_name,
sum(fact_passenger_summary.total_passengers) as total_trips
from
fact_passenger_summary
join
dim_city on fact_passenger_summary.city_id=dim_city.city_id
group by
dim_city.city_name
order by
total_trips DESC
limit 3;
 -- top city--


-- 2 ---
select city_name,
sum(fact_passenger_summary.total_passengers) as total_trips
from
fact_passenger_summary
join
dim_city on fact_passenger_summary.city_id=dim_city.city_id
group by
dim_city.city_name
order by
total_trips asc
limit 3;

-- bottom city 3 --


-- 3 --
SELECT 
    city_name,
    AVG(fact_trips.fare_amount) AS average_fare,
    AVG(fact_trips.distance_travelled_km) AS average_trip_distance
FROM 
    fact_trips 
JOIN 
    dim_city  ON fact_trips.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name;
-- avg fare per trip by city --


-- avg rating by city and passenger type --
SELECT 
    dim_city.city_name,
    fact_trips.passenger_type,
    AVG(fact_trips.passenger_rating) AS avg_passenger_rating,
    AVG(fact_trips.driver_rating) AS avg_driver_rating
FROM 
    fact_trips 
JOIN 
    dim_city  ON fact_trips.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, fact_trips.passenger_type;
-- end -- 


-- peak demand month --
SELECT 
    dim_city.city_name,
    DATE_FORMAT(fact_passenger_summary.month, '%Y-%m') AS month,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary 
JOIN 
    dim_city  ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, month
ORDER BY 
    total_trips DESC
LIMIT 1;  -- Highest demand month (Peak Demand)


-- For the lowest demand month, change DESC to ASC. 

SELECT 
    dim_city.city_name,
    DATE_FORMAT(fact_passenger_summary.month, '%Y-%m') AS month,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary 
JOIN 
    dim_city  ON fact_passenger_summary.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, month
ORDER BY 
    total_trips ASC
LIMIT 1;  -- Highest demand month (Peak Demand)

-- For the lowest demand month, change DESC to ASC.


-- weekend vs weekday trip demand by city --
SELECT 
    dim_city.city_name,
    dim_date.day_type,
    SUM(fact_passenger_summary.total_passengers) AS total_trips
FROM 
    fact_passenger_summary 
JOIN 
    dim_city ON fact_passenger_summary.city_id = dim_city.city_id
JOIN 
    dim_date  ON fact_passenger_summary.month = dim_date.start_of_month
GROUP BY 
    dim_city.city_name, dim_date.day_type;
    -- end --


-- repeat passenger frequency and city contribution analysis --
use trips_db;
SELECT 
    dim_city.city_name,
    dim_repeat_trip_distribution.trip_count,
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) AS repeat_passenger_count
FROM 
    dim_repeat_trip_distribution
JOIN 
    dim_city ON dim_repeat_trip_distribution.city_id = dim_city.city_id
GROUP BY 
    dim_city.city_name, dim_repeat_trip_distribution.trip_count
ORDER BY 
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) DESC;





 
  


 


