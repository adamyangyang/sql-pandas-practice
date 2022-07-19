-- Objective: Find the top 5 states with the most 5 stars businesses. Order results by state with the highest 5 star businesses first. If there are ties in the number of businesses, return all unique states. If two states have the same result, sort them in alphabetical order
-- Output: state, num_of_businesss
-- Assumptions:
    -- 1) Each business might have a branch in a different state that is also 5 stars.
    -- 2) is_open column is ignored as the question doesn't ask us to take into account of whether a business is open or closed. 
-- Process:
    -- STEP 1: Check for missing & duplicate data in required columns (business_id, name, state, stars). 
    -- STEP 2: Filter out businesses with only 5 stars & show total count for each state.

-- STEP 1a: Check for missing data in required columns
    -- Result: No missing data
/*
SELECT * 
FROM yelp_business
WHERE business_ID IS NULL 
    OR name IS NULL
    OR state IS NULL
    OR stars IS NULL                */
    
-- STEP 1b: Check for duplicate businesses
    -- Result: Subway and Dairy Queen have 2 business branches in this dataset
/*
SELECT 
    name, COUNT(name) AS tot_count
FROM yelp_business
GROUP BY 1
ORDER BY 2 DESC             */

-- STEP 1c: Validate results from STEP 1b.
    -- Result: Both businesses have a range of 2 - 3 stars, which won't affect our analysis for this dataset.
/*
SELECT 
    business_id, name, state, stars
FROM yelp_business
WHERE name IN ("Subway", "Dairy Queen")             */

-- STEP 2: Start filtering out businesses by only showing those with 5 stars.
    -- Next, count how many total 5 star businesses are there in each state.
    -- Then, order it by total count of 5 stars businesses.
    -- Lastly, limit to top 5 states, while taking into account of 'ties'

SELECT 
    state, COUNT(state) AS tot_count
FROM yelp_business
WHERE stars = 5
GROUP BY 1
ORDER BY 2 DESC, state
LIMIT 6                     -- To account for the 6th state that also has the same number of 5 star businesses as the top 4th or 5th state.