-- Objective: Calculate MoM % change in revenue for the company.
-- Output: year_month, pct_change
-- Assumptions:
    -- 1) purchase_id column is not needed because we want to find total revenue & pct change regardless of a single product's revenue contribution
-- Process:
    -- 1) Get each month's revenue.
    -- 2) Wrap STEP 1 in a sub-query & use LAG( ) to get preveious month's revenue.
    -- 3) Get revenue pct_change by dividing revenue from current month with previous month.

-- STEP 1: Get each month's revenue. 
/*
SELECT 
    DATE_FORMAT(created_at, "%Y-%m") AS yr_mo, 
    SUM(value) AS revenue
FROM sf_transactions
GROUP BY 1
ORDER BY 1                  */

-- STEP 2: Wrap STEP 1 in a sub-query & use LAG( ) to get preveious month's revenue.
WITH monthly_rev AS (
    SELECT
        *,
        LAG(revenue,1) OVER (ORDER BY yr_mo) AS prev_mo_rev
    FROM (
        SELECT 
            DATE_FORMAT(created_at, "%Y-%m") AS yr_mo, 
            SUM(value) AS revenue
        FROM sf_transactions
        GROUP BY 1
        ORDER BY 1    
    ) subq
)

-- STEP 3: Get revenue pct_change by dividing revenue from current month with previous month.
SELECT
    yr_mo,
    ROUND(((revenue - prev_mo_rev) / prev_mo_rev)*100,2) AS rev_pct_chng
FROM monthly_rev
