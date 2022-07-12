-- Objective: Find the email activity rank for each user. 
    -- Then, sort results by users with the highest total emails sent. If two users have the same number of total emails, sort them by their username in alphabetical order. 
-- Output: user, total emails, activity rank
-- Assumptions:
    -- 1) Each row represents 1 email sent.
    -- 2) A user can send more than 1 email on the same day.
    -- 3) We are only interested in emails sent, so the 'to_user' and 'day' column is not needed.
    -- 4) Data does not require cleaning.
-- Process:
    -- STEP 1: For each user, get the total emails sent.
    -- STEP 2: Based on the total emails, show the activity rank for each user. If 2 users have the same total emails, rank them by alphabetical order instead.
    
SELECT 
    from_user, COUNT(from_user) AS total_emails_sent, 
    RANK () OVER(ORDER BY COUNT(from_user) DESC, from_user ASC) AS activity_rank
FROM google_gmail_emails
GROUP BY 1
