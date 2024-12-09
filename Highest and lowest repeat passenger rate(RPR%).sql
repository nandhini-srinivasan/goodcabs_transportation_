

-- highest repeat passenger analysis --
use trips_db;
use targets_db;
SELECT 
    dim_city.city_name,
    dim_repeat_trip_distribution.trip_count,
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) AS repeat_passenger_count
FROM 
    trips_db.dim_repeat_trip_distribution
JOIN 
    trips_db.dim_city 
    ON trips_db.dim_repeat_trip_distribution.city_id = trips_db.dim_city.city_id
GROUP BY 
    dim_city.city_name, dim_repeat_trip_distribution.trip_count
ORDER BY 
    repeat_passenger_count DESC
LIMIT 1000;

-- lowest repeat passenger analysis --
SELECT 
    dim_city.city_name,
    dim_repeat_trip_distribution.trip_count,
    SUM(dim_repeat_trip_distribution.repeat_passenger_count) AS repeat_passenger_count
FROM 
    trips_db.dim_repeat_trip_distribution
JOIN 
    trips_db.dim_city 
    ON trips_db.dim_repeat_trip_distribution.city_id = trips_db.dim_city.city_id
GROUP BY 
    dim_city.city_name, dim_repeat_trip_distribution.trip_count
ORDER BY 
    repeat_passenger_count asc
LIMIT 1000;

