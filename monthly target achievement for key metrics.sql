SELECT * FROM trips_db.fact_passenger_summary LIMIT 10;
SELECT * FROM targets_db.monthly_target_trips LIMIT 10;

SELECT *
FROM trips_db.fact_passenger_summary
JOIN trips_db.dim_city ON fact_passenger_summary.city_id = dim_city.city_id
LIMIT 10;

-- monthly target achievement for key metrics --
SELECT 
    COALESCE(dim_city.city_name, 'Unknown') AS city_name,
    COALESCE(targets_db.monthly_target_trips.month, 'No Target') AS target_month,
    MAX(targets_db.monthly_target_trips.total_target_trips) AS total_target_trips,
    MAX(targets_db.monthly_target_new_passengers.target_new_passengers) AS target_new_passengers,
    MAX(targets_db.city_target_passenger_rating.target_avg_passenger_rating) AS target_avg_passenger_rating,
    SUM(fact_passenger_summary.total_passengers) AS actual_total_passengers,
    SUM(fact_passenger_summary.new_passengers) AS actual_new_passengers,
    AVG(fact_trips.passenger_rating) AS actual_avg_passenger_rating
FROM 
    trips_db.fact_passenger_summary 
LEFT JOIN 
    trips_db.fact_trips ON fact_passenger_summary.city_id = fact_trips.city_id 
                        AND fact_passenger_summary.month = DATE_FORMAT(fact_trips.date, '%Y-%m')
LEFT JOIN 
    trips_db.dim_city ON fact_passenger_summary.city_id = dim_city.city_id
LEFT JOIN 
    targets_db.monthly_target_trips ON fact_passenger_summary.city_id = targets_db.monthly_target_trips.city_id 
                                     AND fact_passenger_summary.month = targets_db.monthly_target_trips.month
LEFT JOIN 
    targets_db.monthly_target_new_passengers ON fact_passenger_summary.city_id = targets_db.monthly_target_new_passengers.city_id 
                                              AND fact_passenger_summary.month = targets_db.monthly_target_new_passengers.month
LEFT JOIN 
    targets_db.city_target_passenger_rating ON fact_passenger_summary.city_id = targets_db.city_target_passenger_rating.city_id
GROUP BY 
    dim_city.city_name, targets_db.monthly_target_trips.month;
