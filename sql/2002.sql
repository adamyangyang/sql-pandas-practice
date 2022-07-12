-- Objective: Return all users that have created at least 1 submission in 'Refinance' AND 'InSchool'
-- Output: user_id, type
-- Assumptions: Not all users have submitted both refinance & inschool submissions
-- Process: 
    -- STEP 1: Get all users who have submitted for Refinance
    -- Step 2: Get all users who have submitted for Inschool
    -- Step 3: Use inner join on Step 1 query with Step 2 query to return only those who have submitted for 'Refinance' & 'InSchool'
    -- Step 4: Use SELECT DISTINCT to remove duplicate user_id

SELECT DISTINCT loans.user_id
FROM loans
INNER JOIN (
    SELECT user_id
    FROM loans
    WHERE type = "Refinance"
    ) inschool
ON inschool.user_id = loans.user_id
WHERE type = "InSchool"
