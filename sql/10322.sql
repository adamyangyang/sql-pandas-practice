-- Objective: Find all returning active users by user_id column. 
-- Output: user_id
-- Assumptions: 
    -- 1) Data is clean.
    -- 2) If a user has not made a second purchase within 7 days, but does so after, then we should exclude them as well.
    -- 3) Users who make another purchase on the same date should also be counted as a returning user.
    -- 4) After each new purchase, the 7 day interval for each user gets 'refreshed', which starts again until the user no longer buys within that 7 day range.
-- Process:
    -- STEP 1: Get each users next purchase date.
    -- STEP 2: Return users who made a purchase within the last 7 days of any of their purchase dates.

-- STEP 1: Get each users next purchase date.
    -- This lets us remove users who only purchase once.
    -- This also lets us check if the user made a purchase within 7 days of their first purhcase. 
    -- Moreover, it accounts for users who have made a 2nd purchase on the same date.

WITH user_purchase_dates AS (
    SELECT
        user_id, 
        created_at, 
        LEAD(created_at, 1) OVER(PARTITION BY user_id ORDER BY created_at) AS next_purchase_date
    FROM amazon_transactions
    ORDER BY 1, 2
) 
    

-- STEP 2: Return users who made a purchase within the last 7 days of their last purchased date.
    -- Done so by checking if their next purchase date is within the 7 day range of the 'created_at' column
SELECT 
    DISTINCT user_id
FROM user_purchase_dates   
WHERE next_purchase_date <= DATE_ADD(created_at, INTERVAL 7 DAY)