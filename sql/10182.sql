-- Objective: Find the number of different street names for each postal code.
-- Output: postal code, num_of_street_names
-- Assumptions:
    
-- Process: 
    -- STEP 1: Check for missing in required columns (business_postal_code, business_address)
        -- Duplicates are not needed because multiple businesses reside within the same business address and/or postal code.

-- Option 1: Step-by-step process
-- STEP 1a: Check for missing data in the required columns
    -- 6 businesses have no postal codes, but has business addresses. 3 of them has latitude & longitude.
/*
SELECT * 
FROM sf_restaurant_health_violations
WHERE business_postal_code IS NULL
    OR business_address IS NULL                 */
    
-- STEP 2: Count total number of businesses within each state & address.
    -- Also, use lower() to convert street names into lowercase to count all of them.
WITH lower_add AS (
    SELECT 
        business_postal_code AS postal_code,
        lower(business_address) AS business_address, 
        COUNT(business_address) AS tot_count
    FROM sf_restaurant_health_violations
    GROUP BY 1, 2
    ORDER BY 2, 3 DESC
),

-- STEP 3a: Extract first part of business street name (a.k.a the name after the leading numbers)
    -- Find all addresses that do not have numbers starting at the front.
/*
SELECT *
FROM lower_add
WHERE REGEXP_LIKE(business_address, "^[a-z]")
    OR NOT REGEXP_LIKE(business_address, "[0-9]")               */

-- STEP 3b: Include arbitrary number in front of all business address
    -- Use REGEXP_LIKE( ) for 'pattern matching' to find all addresses that starts with a letter instead of a number.
    -- Then, replace with arbitrary number '0' with an empty space.
    -- Next, use REGEXP_LIKE( ) again but exclude those with a number to account for addresses that didn't match in the first condition.
new_business_add AS (
    SELECT
        *,
        CASE
            WHEN REGEXP_LIKE(business_address, "^[a-z]") THEN CONCAT("0 ", business_address)
            WHEN NOT REGEXP_LIKE(business_address, "[0-9]") THEN CONCAT("0 ", business_address)
            ELSE business_address
        END AS business_address_new
    FROM lower_add 
),

-- STEP 3c: Remove all numbers from the front & extract the first part of the street name from each business address
    -- Use SUBSTRING_INDEX( ) to get the first characters before the first empty space delimiter
    -- Use Replace( ) to replace the the cleaned business address column with the first pair of characters from SUBSTRING_INDEX( ), and replace the first pair with an empty space.
        -- This will then return the characters after the empty space delimiter.
    -- Use Trim( ) to remove trailing & leading whitespaces.
    -- Use SUBSTRING_INDEX( ) again to extract only the first 

first_street_name_add AS ( 
    SELECT
        postal_code,
        SUBSTRING_INDEX(TRIM(BOTH " " FROM REPLACE(business_address_new, SUBSTRING_INDEX(business_address_new, " ", 1), "")), " ", 1) AS cleaned_add,
        tot_count
    FROM new_business_add
)

-- STEP 4: Count the distinct street addresses within each postal code.
    -- Also, exclude the empty postal code because the question didn't specify what to do with it.
SELECT
    postal_code, COUNT(DISTINCT cleaned_add) AS tot_count
FROM first_street_name_add
WHERE postal_code IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC, 1                      

-- Option 2: More optimized query.
/*
SELECT
    postal_code, COUNT(DISTINCT cleaned_add) AS tot_street_adds
FROM (
    SELECT
        CASE
            WHEN REGEXP_LIKE(business_address, "^[0-9]") = 1 THEN LOWER(SUBSTRING_INDEX(SUBSTRING_INDEX(business_address, " ", 2), " ", -1))
            ELSE LOWER(SUBSTRING_INDEX(business_address, " ", 1))
        END AS cleaned_add,
        business_postal_code AS postal_code 
    FROM sf_restaurant_health_violations
) subq
WHERE postal_code IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC, 1                      */