-- Objective: Find out how many orders are there for each status in each service
-- Output: service_name, status_of_order, number_of_orders
-- Assumptions: ?
-- Process: 
    -- Step 1: Select on the relevant columns
    -- Step 2: Group by service_name & status_of_order
    -- Step 3: Order by service name in ascending order first & total orders by descending next.

SELECT
    service_name, status_of_order, SUM(number_of_orders) AS tot_orders
FROM uber_orders
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
