-- Objective: Find the popularity percentage of each FB user.
-- Output: user_id, popularity percentage
-- Process:
    -- STEP 1: Get the total number of users in the current dataset
    -- STEP 2: Count the total number of friends each users have.
    -- STEP 3: Get each user's popularity percentageon Facebook.

-- STEP 1: Get total users by using combining all users from user1 & user2 column.
    -- Done so by using UNION to remove duplicate users.
WITH user_id_table AS (
    SELECT user1 AS user_id FROM facebook_friends
    UNION
    SELECT user2 AS user_id FROM facebook_friends
    ORDER BY 1
),

-- STEP 2: Count the total number of friends each users have.
    -- Count how many friends each user has from user2 column.
    -- Repeat the same for user1 column.
    -- Then, use UNION to combine into one dataset & add up the number of friends each user have.
total_friends_by_users AS (
    SELECT
        user_id, SUM(num_of_friends) AS total_friends
    FROM
    (
        (SELECT 
            t1.user_id, COUNT(t2.user2) AS num_of_friends
        FROM user_id_table t1
        LEFT JOIN facebook_friends t2
            ON t2.user1 = t1.user_id
        GROUP BY 1)
        UNION
        (SELECT 
            t1.user_id, COUNT(t2.user1) AS num_of_friends
        FROM user_id_table t1
        LEFT JOIN facebook_friends t2
            ON t2.user2 = t1.user_id
        GROUP BY 1)
    ) subq
    GROUP BY 1
)

-- STEP 3: Get popularity percentage for each user on Facebook.
    -- We get the percetange by dividing each user's total friend count against the total number of users (retrieved via a subquery that counts total users)
SELECT
    user_id, 
    (total_friends / (SELECT COUNT(user_id) FROM user_id_table))*100 AS pop_pct
FROM total_friends_by_users