-- Objective: Find all posts that were reacted with a heart
-- Output: All columns from facebook_posts table for posts with a 'heart' reaction
-- Assumptions: A post should be counted if it has at least 1 heart.
-- Process:
    -- STEP 1: Filter out posts to only show those with a heart reaction
    -- STEP 2: Wrap STEP 1 in a subquery & inner join to facebook_posts table through the key 'post_id'
    -- STEP 3: Remove duplicates by using SELECT DISTINCT

SELECT
    DISTINCT p.*
FROM facebook_posts p
JOIN (
        SELECT post_id
        FROM facebook_reactions
        WHERE reaction = "heart"
    ) r
ON r.post_id = p.post_id;
