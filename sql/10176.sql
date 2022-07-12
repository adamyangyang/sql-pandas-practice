-- Objective: For each bike, find the last time it was used
-- Output: bike_number, end_time
-- Assumption: All bikes are returned and no bikes are still in used (no end time yet)
-- Process:
    -- Step 1: Group by bike_number
    -- Step 2: Use MAX() in each bike_number to get the latest time the bike ride was ended & returned


SELECT
    bike_number, MAX(end_time) AS time_last_used
FROM dc_bikeshare_q1_2012
GROUP BY 1 
ORDER BY 2 DESC
