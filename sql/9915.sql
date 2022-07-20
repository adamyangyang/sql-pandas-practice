-- Objective: Find the customer with highest daily total order cost between Feb 1st 2019 to May 1st 2019.
-- Output: first_name, total_item_cost, date
-- Assumptions: 
    -- 1) Each customer only has one unique id in this dataset (ex: customers don't have two different accounts ordering the same thing)
    -- 2) Cleaned data.
-- Process: 
    -- STEP 1: Return records from specified date range & get total cost.
    -- STEP 2: Join back CTE table to customers table & get the customer with highest total cost.
    
-- STEP 1: Return records from specified date range & get total cost. 
        -- Next, get the total cost for each customer per day. Then, order results by earliest date first, and highest total cost next for quick data valdatio
WITH order_details AS (
    SELECT 
        order_date, cust_id, SUM(total_order_cost) AS total_cost
    FROM orders o
    WHERE order_date BETWEEN "2019-02-01" AND "2019-05-01"
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC
)

-- STEP 2: Join back CTE table to customers table for each customer's first name.
    -- Then, order results by highest total cost & show only the top customer.
SELECT
    od.order_date, c.first_name, od.total_cost
FROM order_details od
JOIN customers c
    ON c.id = od.cust_id
ORDER BY 3 DESC
LIMIT 1