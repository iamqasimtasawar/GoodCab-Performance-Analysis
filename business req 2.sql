#Montly city level trip Target Performance Report

SELECT
    dc.city_name,
    DATE_FORMAT(tri.date, '%M') AS month_name,  -- Extract month name (e.g., "January") from the date
    COUNT(tri.trip_id) AS actual_trips,
    CASE
        WHEN COUNT(tri.trip_id) > tra.total_target_trips THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance_status,
    ROUND(((COUNT(tri.trip_id) - tra.total_target_trips) * 100.0 / tra.total_target_trips), 2) AS percent_difference
FROM 
    trips_db.fact_trips AS tri
JOIN 
    trips_db.dim_city AS dc
    ON dc.city_id = tri.city_id
JOIN
    targets_db.monthly_target_trips AS tra
    ON tra.city_id = tri.city_id
GROUP BY
    dc.city_name,
    DATE_FORMAT(tri.date, '%M'),  -- Group by the extracted month name
    tra.total_target_trips
ORDER BY
    month_name,
    dc.city_name;

