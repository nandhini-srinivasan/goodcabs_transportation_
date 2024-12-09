
use targets_db;
use trips_db;
-- RPR% Analysis by City
-- Calculate RPR% for each city and month
WITH City_RPR AS (
    SELECT 
        dim_city.city_name,
        fact_passenger_summary.month,
        SUM(fact_passenger_summary.repeat_passengers) AS total_repeat_passengers,
        SUM(fact_passenger_summary.total_passengers) AS total_passengers,
        (SUM(fact_passenger_summary.repeat_passengers) / SUM(fact_passenger_summary.total_passengers)) * 100 AS rpr_percentage
    FROM 
        trips_db.fact_passenger_summary
    JOIN 
        trips_db.dim_city ON fact_passenger_summary.city_id = dim_city.city_id
    GROUP BY 
        dim_city.city_name, fact_passenger_summary.month
),
Top_Cities AS (
    SELECT 
        city_name, 
        AVG(rpr_percentage) AS avg_rpr_percentage
    FROM 
        City_RPR
    GROUP BY 
        city_name
    ORDER BY 
        avg_rpr_percentage DESC
    LIMIT 2 -- Top 2 Cities
),
Bottom_Cities AS (
    SELECT 
        city_name, 
        AVG(rpr_percentage) AS avg_rpr_percentage
    FROM 
        City_RPR
    GROUP BY 
        city_name
    ORDER BY 
        avg_rpr_percentage ASC
    LIMIT 2 -- Bottom 2 Cities
)
-- Combine Top and Bottom Cities
SELECT 
    city_name, 
    avg_rpr_percentage 
FROM 
    Top_Cities
UNION ALL
SELECT 
    city_name, 
    avg_rpr_percentage 
FROM 
    Bottom_Cities;

-- RPR% Analysis by Month
SELECT 
    fact_passenger_summary.month,
    SUM(fact_passenger_summary.repeat_passengers) AS total_repeat_passengers,
    SUM(fact_passenger_summary.total_passengers) AS total_passengers,
    (SUM(fact_passenger_summary.repeat_passengers) / SUM(fact_passenger_summary.total_passengers)) * 100 AS rpr_percentage
FROM 
    trips_db.fact_passenger_summary
GROUP BY 
    fact_passenger_summary.month
ORDER BY 
    rpr_percentage DESC;


