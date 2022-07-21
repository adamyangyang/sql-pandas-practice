-- Objective: Count the number of violations from inspections for 'Roxanne Cafe' in each year. 
-- Output: year, total_violations
-- Assumptions:
    -- 1) Data is clean.
    -- 2) The most important columsn are violation_id, inspection_date, and business_name.
    -- 3) There is only one business called 'Roxanne Cafe'. No other separate ones in other cities or state.
-- Process:
    -- STEP 1: Show Roxanne Cafe records. Extract the year from date column & count total violations by year. Then, order results by year in ascending order.

-- STEP 1: Show only records for Roxanne Cafe. 
    -- Then, extract year from date column, and count total violations by year.
    -- Lastly, order results by year in ascending order.
SELECT 
    YEAR(inspection_date) AS inspection_yr,
    COUNT(violation_id) AS total_violations 
FROM sf_restaurant_health_violations
WHERE business_name = "Roxanne Cafe"
GROUP BY 1
ORDER BY 1