-- Objective: Classift each business as either a restaurant, cafe, school, or other.
-- Output: business_name, business_type  
-- Assumptions: 
    -- 1) There could be businesses that fall into more than one category.
    -- 2) The most important data-point is the business_name column, which means the rest of the columns can be ignored.
-- Process: 
    -- STEP 1: Change all names into lowercase so CASE function can take into account of names without capital letters. 
        -- Then, classify business according to their categories.
        -- Also, remove duplicates. 
    
-- STEP 1: Change all names into lowercase so CASE function can take into account of names without capital letters.
WITH biz_types AS (
    SELECT 
        business_name,
        CASE 
            WHEN LOWER(business_name) LIKE "%restaurant%" THEN "Restaurant"
            WHEN LOWER(business_name) LIKE "%cafe%" OR business_name LIKE "%café%" OR LOWER(business_name) LIKE "%coffee%" THEN "Cafe"
            WHEN LOWER(business_name) LIKE "%school%" THEN "School"
            ELSE "Other"
        END AS business_type
    FROM sf_restaurant_health_violations
    WHERE business_id NOT IN (86354,85051,80302,32823) -- remove duplicate business name based on question's definition of 'duplicates'
) 


SELECT 
    business_name, business_type
FROM biz_types
ORDER BY 1