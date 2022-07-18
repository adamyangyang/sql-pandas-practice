-- Objective: Find the minimum, maximum, and average rental prices for each host's popularity rating.
-- Output: popularity_rating, min_price, max_price, avg_price
-- Assumptions: 
    -- 1) We're only looking at a snapshot of the data within a certain time period because user reviews ever-growing & changing. This means a host's popularity rating might drop or increase tomorrow / day after / week after etc.
-- Process:
    -- STEP 1: Create host_id & assign popularity rating.
    -- STEP 2: Get the min, max & average prices for each popularity rating.

-- STEP 1: Create host_id by grouping together price, room_type, host_since, zip_code & number of reviews.
    -- Use ROW_NUMBER() with the kwarg 'ORDER BY' on the host_since column because they signed up as hosts earlier, which means they get assigned an 'earlier' id.
    -- Also, assign each host a popularity rating based on the number of reviews given.
WITH hosts_table AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY host_since ASC) AS host_id,
        host_since, room_type, zipcode, price, number_of_reviews,
        CASE
            WHEN number_of_reviews > 40 THEN "Hot"
            WHEN number_of_reviews >= 16 THEN "Popular"
            WHEN number_of_reviews >= 6 THEN "Trending Up"
            WHEN number_of_reviews>= 1 THEN "Rising"
            ELSE "New"
        END AS pop_rating
    FROM airbnb_host_searches
    GROUP BY 2, 3, 4, 5, 6
    ORDER BY 2 ASC
)

-- STEP 2: Get the min, max & avg rental prices for each popularity rating
SELECT
    pop_rating, 
    MIN(price) AS min_price, MAX(price) AS max_price,
    AVG(price) AS avg_price
FROM hosts_table
GROUP BY 1 
ORDER BY number_of_reviews