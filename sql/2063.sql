-- Objective: Show the difference in value for all the currencies' exchange rate between Jan 2020 and Jul 2020
-- Output: source_currency, exchange_rate
-- Assumptions: ?
-- Process:
    -- STEP 1: Show the exchange rate for all currencies in Jan 2020 only
    -- STEP 2: Repeate STEP 1, but for Jul 2020 only.
    -- STEP 3: Inner join STEP 1 & STEP 2 query. Then, show the exchange rate for both Jan & July.
    -- STEP 4: Get the exchange rate value difference between Jan & Jul

SELECT
    jul_query.source_currency,      -- No difference in using jan or jul_query because they have been inner joined to the same id pairs 
    jul_query.exchange_rate - jan_query.exchange_rate AS exchange_rate_diff
FROM sf_exchange_rate jul_query
INNER JOIN (
            SELECT 
                source_currency, exchange_rate
            FROM sf_exchange_rate
            WHERE date = "2020-01-01" 
            ) jan_query
ON jan_query.source_currency = jul_query.source_currency
WHERE date = "2020-07-01";
