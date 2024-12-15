WITH ranked_cities AS (
    SELECT
        c.city_name,
        SUM(fp.new_passengers) AS total_new_passengers,
        RANK() OVER (ORDER BY SUM(fp.new_passengers) DESC) AS rank_desc,
        RANK() OVER (ORDER BY SUM(fp.new_passengers) ASC) AS rank_asc
    FROM
        trips_db.fact_passenger_summary AS fp
    JOIN
        trips_db.dim_city AS c
        ON c.city_id = fp.city_id
    GROUP BY
        c.city_name
)
SELECT
    city_name,
    total_new_passengers,
    CASE
        WHEN rank_desc <= 3 THEN 'Top 3'
        WHEN rank_asc <= 3 THEN 'Bottom 3'
        ELSE NULL
    END AS city_category
FROM
    ranked_cities
WHERE
    rank_desc <= 3 OR rank_asc <= 3
ORDER BY
    city_category;
