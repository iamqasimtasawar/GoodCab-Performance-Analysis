#City Level Fare and Trip Summary

SELECT
    dc.city_name,
    COUNT(tri.trip_id) AS Total_trips,
    AVG(tri.fare_amount / tri.distance_travelled_km) AS AVG_Fare_perkm,
    AVG(tri.fare_amount) AS AVG_fare_pertrip,
    ROUND((COUNT(tri.trip_id) * 100.0 / (SELECT COUNT(*) FROM trips_db.fact_trips)), 2) AS Percentage_Contribution_To_Total_Trips
FROM 
    trips_db.fact_trips AS tri
JOIN
    trips_db.dim_city AS dc
ON 
    dc.city_id = tri.city_id
GROUP BY
    dc.city_name
ORDER BY
    Total_trips DESC; 