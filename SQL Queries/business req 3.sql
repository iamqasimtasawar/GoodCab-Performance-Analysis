#City-Level Repeat Passenger Trip Frequency Report

WITH city_total_repeat_passengers AS (
    SELECT
        dc.city_name,
        SUM(dr.repeat_passenger_count) AS total_repeat_passengers
    FROM
        trips_db.dim_repeat_trip_distribution AS dr
    JOIN
        trips_db.dim_city AS dc
    ON
        dr.city_id = dc.city_id
    GROUP BY
        dc.city_name
),
trip_frequency_percentage AS (
    SELECT
        dc.city_name,
        ROUND(SUM(CASE WHEN dr.trip_count = '2-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `2-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '3-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `3-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '4-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `4-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '5-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `5-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '6-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `6-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '7-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `7-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '8-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `8-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '9-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `9-Trips`,
        ROUND(SUM(CASE WHEN dr.trip_count = '10-Trips' THEN dr.repeat_passenger_count ELSE 0 END) * 100.0 / ctp.total_repeat_passengers, 2) AS `10-Trips`
    FROM
        trips_db.dim_repeat_trip_distribution AS dr
    JOIN
        trips_db.dim_city AS dc
    ON
        dr.city_id = dc.city_id
    JOIN
        city_total_repeat_passengers AS ctp
    ON
        dc.city_name = ctp.city_name
    GROUP BY
        dc.city_name, ctp.total_repeat_passengers
)
SELECT
    city_name,
    `2-Trips`,
    `3-Trips`,
    `4-Trips`,
    `5-Trips`,
    `6-Trips`,
    `7-Trips`,
    `8-Trips`,
    `9-Trips`,
    `10-Trips`
FROM
    trip_frequency_percentage
ORDER BY
    city_name;