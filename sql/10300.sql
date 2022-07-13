-- Objective: Find the total number of downloads for paying & non-paying users by date, on the days where non-paying user downloads are more than paying users.
-- Output: date, non-paying downloads, paying downloads
-- Assumptions:
    -- 1) Each user can only have one acc_id
        -- Edit: The null hypothesis is false as each acc_id can have multiple users after doing quick EDA in STEP 1
-- Process:
    -- STEP 1: Check whether each user has only one acc_id (or if there are duplicates) 
    -- STEP 2: Join ms_user_dimension table to ms_acc_dimension table to see which accounts are paying or non-paying users
    -- STEP 3: Show total paying and non-paying download for all dates through GROUP BY ( ) and SUM( ) with CASE function.
    -- STEP 4: Show the days where non-paying downloads are more than paying downloads.

-- STEP 1a: Check whether user_id has duplicates
    -- There are no duplicate user ids
/*
SELECT 
    user_id, COUNT(user_id) AS total_count
FROM ms_user_dimension
GROUP BY 1
ORDER BY 2 DESC                */

-- STEP 1b: Check whether acc_id has duplicates
    -- There are acc_ids that appear several times.
/*
SELECT 
    acc_id, COUNT(acc_id) AS total_count
FROM ms_user_dimension
GROUP BY 1
HAVING COUNT(acc_id) > 1
ORDER BY 2 DESC      */            

-- For accounts with more than 1 user, check if each users can belong to only one category (paying or non-paying users), or both (paying and non-paying users for different user_ids)
    -- Edit: Each acc can only have one single category (paying or non-paying users)
/*
SELECT 
    t2.acc_id, 
    COUNT(CASE WHEN paying_customer = "no" THEN user_id END) AS non_paying_users,
    COUNT(CASE WHEN paying_customer = "yes" THEN user_id END) AS paying_users
FROM ms_user_dimension t1
JOIN ms_acc_dimension t2
ON t2.acc_id = t1.acc_id
WHERE t2.acc_id IN (
                SELECT 
                    acc_id
                FROM ms_user_dimension
                GROUP BY 1
                HAVING COUNT(acc_id) > 1
                )
GROUP BY 1                                      */

-- STEP 2: Join 3 tables together.
    -- ms_user_dimensions with ms_acc_dimensions through 'acc_id'
    -- ms_user_dimensions with ms_download_facts through 'user_id'
    -- Once done, wrap the query in a CTE table.
WITH t1 AS (
    SELECT
        date, 
        user_dim.user_id, acc_dim.acc_id, acc_dim.paying_customer,
        downloads
    FROM ms_user_dimension user_dim
    JOIN ms_acc_dimension acc_dim
        ON acc_dim.acc_id = user_dim.acc_id
    JOIN ms_download_facts downloads
        ON downloads.user_id = user_dim.user_id
)

-- STEP 3 & 4: For each date, show total paying & non-paying user downloads through GROUP BY ( ) and SUM & CASE function.
    -- After that, wrap the above query in a sub-query and show the dates where non_paying downloads are more than paying downloads.
SELECT
    *
FROM (
        SELECT 
            date, 
            SUM(CASE WHEN paying_customer = "no" THEN downloads END) AS "non_paying_downloads",
            SUM(CASE WHEN paying_customer = "yes" THEN downloads END) AS "paying_downloads"
        FROM t1
        GROUP BY 1
        ORDER BY 1
) subq
WHERE non_paying_downloads > paying_downloads
