-- Objective: For each date, the difference between 'distance-per-dollar' and the average distance-per-dollar for each date's 'year-month'
-- Output: year_month, absolute average difference in distance-per-dollar (rounded to 2nd decimal), success_request_status, failed_request_status
-- Assumptions:
    -- 1) All dates are unique in the dataset.
    -- 2) The driver_to_client_distance column is not required for calculating 'distance per dollar' or 'average distance per dollar'
    -- 3) Records with 'success' or 'fail' request status should be included in the dataset.
-- Process:
    -- STEP 1: Find the distance-per-dollar for each ride on a daily basis. 
        -- Divide distance_to_travel against monetary_cost.
        -- Get each date's year_month using DATEFORMAT( ).
    -- STEP 2: Find the average distance-per-dollar for each month. 
        -- Use AVG( ) on STEP 1's distance-per-dollar value, while grouping by year month column.
    -- 3) Get each year_month's absolute average difference and sort by earliest request date first.

-- STEP 1: Find the distance-per-dollar for each ride on a daily basis. 
    -- Divide distance_to_travel against monetary_cost to get distance_per_dollar for each date.
    -- Next, get year month column from each date using DATE_FORMAT( ).
/*
SELECT 
    DATE_FORMAT(request_date, "%Y-%m") AS "yr_mo",
    request_date,           -- for validating
    ROUND(distance_to_travel / monetary_cost, 2) AS "distance_per_dollar"
FROM uber_request_logs */

-- STEP 2: Get average distance_per_dollar for each month using AVG( ) & GROUP BY year month column.
WITH t1 AS (
    SELECT 
        DATE_FORMAT(request_date, "%Y-%m") AS "yr_mo",
        AVG(distance_to_travel / monetary_cost) AS avg_distance_per_dollar
    FROM uber_request_logs
    GROUP BY 1        
)

-- STEP 3: For each year month, get the absolute average difference (distance per dollar - avg distance per dollar) using ABS( ) function. 
    -- Then, round to 2 decimals for final output.
SELECT 
    t2.yr_mo AS "year_month",
    ROUND(ABS(distance_per_dollar - avg_distance_per_dollar),2) AS abs_avg_diff
FROM (
    -- Query from STEP 1
    SELECT
        DATE_FORMAT(request_date, "%Y-%m") AS "yr_mo",
        request_date, request_status,
        distance_to_travel / monetary_cost AS "distance_per_dollar"
    FROM uber_request_logs
) t2
JOIN t1
ON t1.yr_mo = t2.yr_mo
GROUP BY 1
ORDER BY 1
