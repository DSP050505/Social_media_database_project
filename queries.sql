-- 1. Most Liked Post
SELECT p.post_id, COUNT(l.like_id) AS like_count
FROM POSTS p
JOIN LIKES l ON p.post_id = l.like_on_id AND l.like_on_type = 'post'
WHERE p.is_deleted = FALSE
GROUP BY p.post_id
ORDER BY like_count DESC
LIMIT 1;

-- 2. Post with Most Comments
SELECT p.post_id, COUNT(c.comment_id) AS comment_count
FROM POSTS p
JOIN COMMENTS c ON p.post_id = c.post_id
WHERE p.is_deleted = FALSE AND c.is_deleted = FALSE
GROUP BY p.post_id
ORDER BY comment_count DESC
LIMIT 1;

-- 3. Most Followed Group
SELECT ug.group_id, COUNT(ugr.user_id) AS follower_count
FROM USER_GROUPS ug
JOIN USER_GROUP_RELATION ugr ON ug.group_id = ugr.group_id
WHERE ug.is_deleted = FALSE
GROUP BY ug.group_id
ORDER BY follower_count DESC
LIMIT 1;

-- 4. Most Followed Page
SELECT p.page_id, COUNT(upr.user_id) AS follower_count
FROM PAGES p
JOIN USER_PAGE_RELATION upr ON p.page_id = upr.page_id
WHERE p.is_deleted = FALSE
GROUP BY p.page_id
ORDER BY follower_count DESC
LIMIT 1;

-- 5. Most Active User (Most Posts)
SELECT u.user_id, u.user_name, COUNT(p.post_id) AS post_count
FROM USERS u
JOIN POSTS p ON u.user_id = p.author_id
WHERE p.is_deleted = FALSE
GROUP BY u.user_id
ORDER BY post_count DESC
LIMIT 1;

-- 6. Most Active User (Most Comments)
SELECT u.user_id, u.user_name, COUNT(c.comment_id) AS comment_count
FROM USERS u
JOIN COMMENTS c ON u.user_id = c.commenter_id
WHERE c.is_deleted = FALSE
GROUP BY u.user_id
ORDER BY comment_count DESC
LIMIT 1;

-- 7. Most Active User (Most Messages Sent)
SELECT u.user_id, u.user_name, COUNT(m.message_id) AS message_count
FROM USERS u
JOIN MESSAGES m ON u.user_id = m.sender_id
GROUP BY u.user_id
ORDER BY message_count DESC
LIMIT 1;

-- 8. Most Active User (Most Messages Received)
SELECT u.user_id, u.user_name, COUNT(m.message_id) AS message_count
FROM USERS u
JOIN MESSAGES m ON u.user_id = m.receiver_id
GROUP BY u.user_id
ORDER BY message_count DESC
LIMIT 1;

-- 9. Most Active Post Type
SELECT post_type, COUNT(post_id) AS post_count
FROM POSTS
WHERE is_deleted = FALSE
GROUP BY post_type
ORDER BY post_count DESC
LIMIT 1;

-- 10. Most Liked Image or Video Post
SELECT p.post_id, COUNT(l.like_id) AS like_count
FROM POSTS p
JOIN LIKES l ON p.post_id = l.like_on_id AND l.like_on_type = 'post'
JOIN IMAGE_VIDEO_POSTS ivp ON p.post_id = ivp.post_id
WHERE p.is_deleted = FALSE AND ivp.post_id IS NOT NULL
GROUP BY p.post_id
ORDER BY like_count DESC
LIMIT 1;

-- 11. Most Commented Image or Video Post
SELECT p.post_id, COUNT(c.comment_id) AS comment_count
FROM POSTS p
JOIN COMMENTS c ON p.post_id = c.post_id
JOIN IMAGE_VIDEO_POSTS ivp ON p.post_id = ivp.post_id
WHERE p.is_deleted = FALSE AND ivp.post_id IS NOT NULL AND c.is_deleted = FALSE
GROUP BY p.post_id
ORDER BY comment_count DESC
LIMIT 1;

-- 12. Most Active Group
SELECT ug.group_id, ug.group_name, COUNT(p.post_id) AS post_count
FROM USER_GROUPS ug
JOIN POSTS p ON ug.group_id = p.group_id
WHERE ug.is_deleted = FALSE AND p.is_deleted = FALSE
GROUP BY ug.group_id
ORDER BY post_count DESC
LIMIT 1;

-- 13. Most Active Page
SELECT p.page_id, p.page_name, COUNT(pst.post_id) AS post_count
FROM PAGES p
JOIN POSTS pst ON p.page_id = pst.page_id
WHERE p.is_deleted = FALSE AND pst.is_deleted = FALSE
GROUP BY p.page_id
ORDER BY post_count DESC
LIMIT 1;

-- 14. Most Commented Post by User
SELECT u.user_id, u.user_name, p.post_id, COUNT(c.comment_id) AS comment_count
FROM USERS u
JOIN POSTS p ON u.user_id = p.author_id
JOIN COMMENTS c ON p.post_id = c.post_id
WHERE p.is_deleted = FALSE AND c.is_deleted = FALSE
GROUP BY u.user_id, p.post_id
ORDER BY comment_count DESC
LIMIT 1;

-- 15. Most Recently Created Post
SELECT post_id, post_type, created_at
FROM POSTS
WHERE is_deleted = FALSE
ORDER BY created_at DESC
LIMIT 1;

-- 16. Most Recently Created Group
SELECT group_id, group_name, created_at
FROM USER_GROUPS
WHERE is_deleted = FALSE
ORDER BY created_at DESC
LIMIT 1;

-- 17. Most Recently Created Page
SELECT page_id, page_name, created_at
FROM PAGES
WHERE is_deleted = FALSE
ORDER BY created_at DESC
LIMIT 1;

-- 18. Total Number of Posts per User
SELECT u.user_id, u.user_name, COUNT(p.post_id) AS total_posts
FROM USERS u
LEFT JOIN POSTS p ON u.user_id = p.author_id AND p.is_deleted = FALSE
GROUP BY u.user_id
ORDER BY total_posts DESC;

-- 19. Total Number of Comments per User
SELECT u.user_id, u.user_name, COUNT(c.comment_id) AS total_comments
FROM USERS u
LEFT JOIN COMMENTS c ON u.user_id = c.commenter_id AND c.is_deleted = FALSE
GROUP BY u.user_id
ORDER BY total_comments DESC;

-- 20. Total Number of Likes per Post
SELECT p.post_id, COUNT(l.like_id) AS total_likes
FROM POSTS p
LEFT JOIN LIKES l ON p.post_id = l.like_on_id AND l.like_on_type = 'post'
WHERE p.is_deleted = FALSE
GROUP BY p.post_id
ORDER BY total_likes DESC;
