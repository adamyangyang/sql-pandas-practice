-- Objective: For each guest reviever, find the nationality of that reviewer's favorite host based on the highest review score given to each host by that reviewer. 
-- Output: from_user, to_user, nationality
-- Assumptions: 
    -- 1) The lowest score is 0 and the highest score is 10. There is no decimal points.
    -- 2) Users can give the same score multiple times.
    -- 3) A user can also give themselves a score?
    -- 4) Favorite host of the reviewer = Highest score given by the same reviewer
    -- 5) A user can also have more than 1 favorite hosts from different countries.
-- Process:
    -- STEP 1: Filter the table to only include from_type as guest and to_type as host.
    -- STEP 2a: Get the highest review score using MAX( ) for each user & group them by from_user (a.k.a the guest reviewer)
    -- STEP 2b: Then, include HAVING( ) clause to quickly check how many favorite hosts each guest reviewer has
    -- STEP 3: Join STEP 2b's query to airbnb_hosts table using to_user = host_id as the condition
    -- STEP 4: Remove duplicates from host table by using SELECT DISTINCT
    -- STEP 5: Inner join STEP 4's from_user to remove  to airbnb_reviews to remove duplicates from nationality by listing the country only once.

SELECT
    from_user, nationality
FROM (
        SELECT
            DISTINCT host_id, rev.from_user, h.nationality
        FROM airbnb_hosts h
        JOIN (
                SELECT
                   from_user, to_user, MAX(review_score) AS score
                FROM airbnb_reviews
                WHERE from_type = "guest" AND to_type = "host"
                GROUP BY from_user, to_user
                HAVING MAX(review_score) = 10
                ORDER BY 1, 2, 3
            ) rev
        ON rev.to_user = h.host_id
        ORDER BY 2 
        ) t1
GROUP BY 1, 2
ORDER BY 1, 2
