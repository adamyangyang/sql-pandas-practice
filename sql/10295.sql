-- Objective: Find the top 10 most active users on Meta's messanger app. The most active users are based on the highest total number of messages sent or received.
-- Output: user, total messages sent, total messages received 
-- Assumptions: 
    -- In social media, users can be both senders and receivers of a message.
    -- This means we need to check for usernames that appear in user1 & user2. 
    -- Also, we'll simply assume that the number of messages sent and received between each user is 1:1.
    -- For instance, if the msg_count between user1 & user2 is 8, that means user1 has sent 4 messages & received 4 messages. 
    -- Similarly, user2 will also have sent 4 messages & received 4 messages. The only difference here is the order of the messages sent or received.
    -- Ex: User1 sends msg1 -> User2 receives msg1.
        -- User2 sends msg2 -> User1 receives msg2.
        -- User1 sends msg3 -> User2 receives msg3, and so forth.
    -- At the end, both will have 8 messages exchanged: 
        -- User1 - 4 messages sent & 4 received
        -- User2 - 4 messages received & 4 sent
-- Process: 
    -- STEP 1a: Check if a user is both a sender & receiver in the table
    -- STEP 1b: Check if there are users who are sneders, but not receivers (or vice-versa).
    -- STEP 2: Get total message exchanges by sender and receiver separately
    -- STEP 3: Use UNION to combine all users into one column, while getting the total number of message exchanges.
    -- STEP 4: Wrap STEP 3 in a sub-query & remove duplicate usernames from result by using GROUP BY ( ) to group users by their name. Then, use SUM( ) to add up the individual message exchanges we got separately from senders and receivers in STEP 3 for grand total of message exchanges.
    -- STEP 5: Use LIMIT 10 to specify Top 10 users
    -- [Optional] STEP 6: Check if the duplicate users 

-- STEP 1a: Get all username from sender's side to check if the table has a user who is both a sender & receiver
    -- Users 'perezanita' & 'brandi30' are both senders & receivers. 
    -- Also, the msg count in id 16 & 19 should be equal, as the sender (user1) in id 16 matches the receiver (user2) in id 19. 
    -- This is also the same for the receiver (user2) in id 16 and sender (user1) in id 19. 
    -- The only logical explanation is that this might be a new conversation started on the same day?
/*
SELECT *
FROM fb_messages
WHERE user2 IN 
    (SELECT user1 FROM fb_messages GROUP BY user1)      */
    
-- STEP 1b: Repeate STEP 1a to check if there are also users who are receivers but not senders.
    -- There are users who receivers but not senders.
/*
SELECT *
FROM fb_messages
WHERE user2 NOT IN 
    (SELECT user1 FROM fb_messages GROUP BY user1)      */
    
-- STEP 2 - 5: Get total msg exchanges by sender & receiver separately. Then, use UNION to combine all users & GROUP BY plus SUM( ) to get grand total number of message exchanges. Finally, use LIMIT 10 to display on the top 10 most active users.

SELECT 
    user, SUM(msg_count) AS tot_msg_exchange
FROM
(
    SELECT
        user1 AS user, msg_count 
    FROM fb_messages
    UNION ALL
    SELECT
        user2 AS user, msg_count
    FROM fb_messages
) subq
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10                    

-- [Optional] STEP 6: Check the total number of messages for users who are senders & receivers

/*
SELECT
    user , msg_count
    -- , SUM(msg_count) AS tot_msg_exch     -- To check if the grand total messages are added up correctly
FROM (
    SELECT
        user1 AS user, msg_count 
    FROM fb_messages
    UNION ALL
    SELECT
        user2 AS user, msg_count
    FROM fb_messages
) users
WHERE user IN ("perezanita", "brandi30")
-- GROUP BY 1                               -- To remove duplicates in users who are both senders & receivers.
ORDER BY 2 DESC                     */
