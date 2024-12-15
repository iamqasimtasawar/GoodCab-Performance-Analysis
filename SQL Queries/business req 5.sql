WITH monthly_revenue AS (
    SELECT
        c.city_name,
        DATE_FORMAT(t.date, '%M') AS month_name,  -- Extract the month name from the trip date
        SUM(t.fare_amount) AS monthly_revenue,    -- Total revenue for each city and month
        SUM(SUM(t.fare_amount)) OVER (PARTITION BY c.city_name) AS total_city_revenue  -- Total revenue for the city
    FROM
        trips_db.fact_trips AS t  -- Fact table containing trip details
    JOIN
        trips_db.dim_city AS c  -- City dimension table
        ON t.city_id = c.city_id  -- Join cities with trips
    GROUP BY
        c.city_name, 
        month_name
),
ranked_revenue AS (
    SELECT
        city_name,
        month_name AS highest_revenue_month,
        monthly_revenue,
        (monthly_revenue * 100.0 / total_city_revenue) AS percentage_contribution,
        RANK() OVER (PARTITION BY city_name ORDER BY monthly_revenue DESC) AS revenue_rank
    FROM
        monthly_revenue
)
SELECT
    city_name,
    highest_revenue_month,
    monthly_revenue AS revenue,
    ROUND(percentage_contribution, 2) AS percentage_contribution
FROM
    ranked_revenue
WHERE
    revenue_rank = 1  -- Only show the month with the highest revenue for each city
ORDER BY
    city_name,
    highest_revenue_month DESC;
