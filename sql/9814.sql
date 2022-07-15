-- Objective: Find the number of times 'bull' & 'bear' occurred in each sentence.
-- Output: all columns, bull_count, bear_count,
-- Process:
    -- STEP 1: Find how many times the word 'bull' and 'bear' occur in each sentence.
    -- STEP 2: Print out the words and its number of occurences.

-- STEP 1: Find how many times 'bull' and 'bear' occur in each content
WITH word_counts AS (
    SELECT 
        filename, contents,
        LENGTH(contents) AS str_len,
        (LENGTH(contents) - LENGTH(REPLACE(contents, "bull", ""))) / LENGTH("bull") AS bull_counts,
        (LENGTH(contents) - LENGTH(REPLACE(contents, "bear", ""))) / LENGTH("bear") AS bear_counts
    FROM google_file_store
)

-- STEP 2: Print out the target 'keyword' & num of times it appeared
SELECT 
    "bull" AS word,
    (SELECT SUM(bull_counts) FROM word_counts) AS word_counts
UNION
SELECT
    "bear" AS word,
    (SELECT SUM(bear_counts) FROM word_counts) AS word_counts
