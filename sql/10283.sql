-- Objective: Find all songs that ranked #1 at least once in the past 20 years
-- Output: year, song_name, year_rank  
-- Assumptions: A song can rank #1 multiple times in a year. If so, remove it because the question wants to find all songs that ranked #1 at least once.
-- Process: 
    -- STEP 1: Filter out songs by showing only those that ranked #1
    -- STEP 2: Remove duplicates using GROUPBY( ) function for year & song_name
        -- 2nd condition (song_name) is just in case 2 different songs rank #1 in the same year

SELECT
    year, song_name
FROM billboard_top_100_year_end
WHERE year_rank = 1
GROUP BY 1, 2
