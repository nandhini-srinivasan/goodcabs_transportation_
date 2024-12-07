-- city level fare and trip summary report --
-- trip volume, pricing efficiency, each city contribution to overall trip count --
use trips_db;
SELECT 
    dc.city_name,
    COUNT(ft.trip_id) AS total_trips,
    AVG(ft.fare_amount / ft.distance_travelled_km) AS avg_fare_per_km,
    AVG(ft.fare_amount) AS avg_fare_per_trip,
    (COUNT(ft.trip_id) * 100.0 / 
     (SELECT COUNT(trip_id) FROM trips_db.fact_trips)) AS percentage_contribution_to_total_trips
FROM 
    trips_db.fact_trips ft
JOIN 
    trips_db.dim_city dc 
ON 
    ft.city_id = dc.city_id
GROUP BY 
    dc.city_name;


-- Monthly City-Level Trips Target Performance Report -This query compares actual trips against target trips by month and city and calculates the performance status and percentage difference. --

SELECT 
    dc.city_name,
    dd.month_name,  -- Correct column name for month
    COUNT(ft.trip_id) AS actual_trips,
    tt.total_target_trips,
    CASE 
        WHEN COUNT(ft.trip_id) > tt.total_target_trips THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance_status,
    ((COUNT(ft.trip_id) - tt.total_target_trips) * 100.0 / tt.total_target_trips) AS percentage_difference
FROM 
    trips_db.fact_trips ft
JOIN 
    trips_db.dim_city dc 
ON 
    ft.city_id = dc.city_id
JOIN 
    trips_db.dim_date dd 
ON 
    ft.date = dd.date  -- Match on the date field
JOIN 
    targets_db.monthly_target_trips tt 
ON 
    ft.city_id = tt.city_id AND dd.start_of_month = tt.month  -- Ensure correct mapping
GROUP BY 
    dc.city_name, dd.month_name, tt.total_target_trips
LIMIT 0, 1000;


-- BR3 City-Level Repeat Passenger Trip Frequency Report --

SELECT 
    dc.city_name,
    dd.month_name,
    rtd.trip_count,  -- Showing the number of trips
    SUM(rtd.repeat_passenger_count) AS repeat_passenger_count
FROM 
    trips_db.dim_repeat_trip_distribution rtd
JOIN 
    trips_db.dim_city dc 
ON 
    rtd.city_id = dc.city_id
JOIN 
    trips_db.dim_date dd 
ON 
    rtd.month = dd.start_of_month
GROUP BY 
    dc.city_name, dd.month_name, rtd.trip_count  -- Grouping by trip count only
ORDER BY 
    repeat_passenger_count DESC
LIMIT 1000;




-- Business Request 4: Cities with Highest and Lowest Total New Passengers --
SELECT 
    dc.city_name,
    dd.month_name,
    SUM(fps.new_passengers) AS total_new_passengers
FROM 
    trips_db.fact_passenger_summary fps
JOIN 
    trips_db.dim_city dc 
ON 
    fps.city_id = dc.city_id
JOIN 
    trips_db.dim_date dd 
ON 
    fps.month = dd.start_of_month
GROUP BY 
    dc.city_name, dd.month_name
ORDER BY 
    total_new_passengers DESC
LIMIT 1; -- For highest


-- To find the city with the lowest total new passengers, 

SELECT 
    dc.city_name,
    dd.month_name,
    SUM(fps.new_passengers) AS total_new_passengers
FROM 
    trips_db.fact_passenger_summary fps
JOIN 
    trips_db.dim_city dc 
ON 
    fps.city_id = dc.city_id
JOIN 
    trips_db.dim_date dd 
ON 
    fps.month = dd.start_of_month
GROUP BY 
    dc.city_name, dd.month_name
ORDER BY 
    total_new_passengers ASC
LIMIT 1; -- For highest





-- Business Request 5: Month with Highest Revenue for Each City --

WITH RevenuePerCityMonth AS (
    SELECT 
        dc.city_name,
        dd.month_name,
        SUM(ft.fare_amount) AS total_revenue
    FROM 
        trips_db.fact_trips ft
    JOIN 
        trips_db.dim_city dc ON ft.city_id = dc.city_id
    JOIN 
        trips_db.dim_date dd ON ft.date = dd.start_of_month
    GROUP BY 
        dc.city_name, dd.month_name
)
SELECT 
    city_name,
    month_name,
    total_revenue
FROM (
    SELECT 
        city_name,
        month_name,
        total_revenue,
        RANK() OVER (PARTITION BY city_name ORDER BY total_revenue DESC) AS revenue_rank
    FROM 
        RevenuePerCityMonth
) AS ranked
WHERE revenue_rank = 1
ORDER BY 
    city_name
LIMIT 1000;




-- Business Request 6: Repeat Passenger Rate Analysis --
SELECT 
    dc.city_name,
    dd.month_name,
    SUM(fps.repeat_passengers) AS repeat_passengers,
    SUM(fps.total_passengers) AS total_passengers,
    (SUM(fps.repeat_passengers) * 100.0 / SUM(fps.total_passengers)) AS repeat_passenger_rate
FROM 
    trips_db.fact_passenger_summary fps
JOIN 
    trips_db.dim_city dc 
ON 
    fps.city_id = dc.city_id
JOIN 
    trips_db.dim_date dd 
ON 
    fps.month = dd.start_of_month
GROUP BY 
    dc.city_name, dd.month_name
ORDER BY 
    repeat_passenger_rate DESC;


