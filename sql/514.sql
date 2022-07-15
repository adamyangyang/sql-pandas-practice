-- Objective: Find the number of users that made additional in-app purchases due to the success of the marketing campaign
-- Output: total users that made additional purchase
-- Assumptions:
    -- 1) Each user's marketing campaign starts on different days depending on when they've first made their purchase.
-- Requirements:
    -- 1) Users that make their 1st in-app purchase are placed in a marketing campaign to see more call-to-actions for more in-app purchase.
    -- 2) The marketing campaign doesn't start until 1 day after users have made their initial in-app purchase.
    -- 3) Users that made one or multiple purchases on the 1st day do not count.
    -- 4) Users that continue to purchase only the same products as they did on the 1st day do not count as well. 
-- Process:
    -- STEP 1: Check for null values in all columns 
    -- STEP 2: Find each user's first purchase date & assign a start date to their marketing campaign.
    -- STEP 3: Filter out users who have not made any purchase after their first purchase date (requirement 3)
    -- STEP 4: Filter out users that only continue to buy the same products as they did on the 1st day (requirement 4)
    -- STEP 5: Count total number of users that made additional in-app purchase

-- STEP 1: Check for null values in all columns
/*
SELECT 
    SUM(CASE WHEN user_id = NULL THEN 1 ELSE 0 END) AS user_id,
    SUM(CASE WHEN created_at = NULL THEN 1 ELSE 0 END) AS created_at,
    SUM(CASE WHEN product_id = NULL THEN 1 ELSE 0 END) AS product_id,
    SUM(CASE WHEN quantity = NULL THEN 1 ELSE 0 END) AS quantity,
    SUM(CASE WHEN price = NULL THEN 1 ELSE 0 END) AS price
FROM marketing_campaign                 */


-- STEP 2: Find each user's first purchase date & assign their marketing campaign's start date.
/*
SELECT 
    user_id, MIN(created_at) AS first_purchase_date,
    DATE_ADD(MIN(created_at), INTERVAL 1 DAY) AS campaign_start_date
FROM marketing_campaign
GROUP BY 1                          */

-- STEP 3: Filter out users who have not made any purchase after their first purchase date
WITH repeat_users AS (
    SELECT 
        user_id, MIN(created_at) AS first_purchase_date,
        DATE_ADD(MIN(created_at), INTERVAL 1 DAY) AS campaign_start_date,
        MAX(created_at) AS last_purchase_date
    FROM marketing_campaign
    GROUP BY 1
    HAVING MAX(created_at) != MIN(created_at)
),

-- STEP 4a: Find the products each repeat user bought on their first day
    -- We'll use GROUP_CONCAT( ) with 'DISTINCT' keyword argument to group together all products purchased by each user on their first day.
    -- Then, we use ORDER BY to order the product_id in ascending order.
products_bought_by_repeat_users_on_first_day AS (
    SELECT 
        t1.user_id,
        GROUP_CONCAT(DISTINCT t1.product_id ORDER BY t1.product_id ASC) AS day_one_products
    FROM marketing_campaign t1
    JOIN repeat_users t2
        ON t2.user_id = t1.user_id
        AND t2.first_purchase_date = t1.created_at
    WHERE t1.user_id IN (SELECT user_id FROM repeat_users)
    GROUP BY 1
),

-- STEP 4b: Filter out users that only continue to buy the same products as they did on the 1st day
	-- We'll use 'NOT' and 'FIND_IN_SET( )' to check if each user is buying a product that is not bought on their first_purchase_date.
repeat_users_w_product_purchase_diff_from_day_one AS (
    SELECT 
        t1.user_id, t1.created_at, t1.product_id,
        t3.day_one_products
    FROM marketing_campaign t1
    JOIN repeat_users t2
        ON t2.user_id = t1.user_id
    JOIN products_bought_by_repeat_users_on_first_day t3
        ON t3.user_id = t1.user_id
    WHERE t1.user_id IN (SELECT user_id FROM repeat_users)
        AND t1.created_at > t2.first_purchase_date
        AND NOT FIND_IN_SET(t1.product_id, t3.day_one_products)
)

-- STEP 5: Count total number of users that made additional in-app purchase
SELECT 
    COUNT(DISTINCT user_id) AS total_users
FROM repeat_users_w_product_purchase_diff_from_day_one
