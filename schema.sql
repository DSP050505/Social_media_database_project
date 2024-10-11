-- USERS table: Stores user information
CREATE TABLE USERS (
    user_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for each user
    user_name VARCHAR(100) NOT NULL,               -- User's display name
    email VARCHAR(100) NOT NULL UNIQUE,            -- User's email address, unique constraint
    password VARCHAR(255) NOT NULL,                -- User's hashed password
    DOB DATE,                                      -- User's date of birth
    gender CHAR(1),                                -- User's gender (e.g., M, F, O)
    is_deleted BOOLEAN DEFAULT 0                   -- Soft delete flag for logical deletion
);

-- USER_GROUPS table: Stores group details
CREATE TABLE USER_GROUPS (
    group_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for each group
    group_name VARCHAR(100) NOT NULL,               -- Name of the group
    group_details TEXT,                            -- Details about the group
    admin INT,                                     -- User ID of the group's admin
    is_deleted BOOLEAN DEFAULT 0,                  -- Soft delete flag for logical deletion
    FOREIGN KEY (admin) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- PAGES table: Stores page details
CREATE TABLE PAGES (
    page_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each page
    page_name VARCHAR(100) NOT NULL,                -- Name of the page
    page_details TEXT,                             -- Details about the page
    created_by_id INT,                             -- User ID of the page creator
    is_deleted BOOLEAN DEFAULT 0,                  -- Soft delete flag for logical deletion
    FOREIGN KEY (created_by_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- POSTS table: Stores posts details
CREATE TABLE POSTS (
    post_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each post
    author_id INT,                                 -- User ID of the post author
    group_id INT NULL,                             -- Group ID if the post is related to a group
    page_id INT NULL,                              -- Page ID if the post is related to a page
    user_timeline_id INT NULL,                     -- User ID if the post is related to a user timeline
    post_type VARCHAR(50) NOT NULL,                -- Type of the post (e.g., text, image, video)
    is_deleted BOOLEAN DEFAULT 0,                 -- Soft delete flag for logical deletion
    FOREIGN KEY (author_id) REFERENCES USERS(user_id),  -- Foreign key referencing USERS table
    FOREIGN KEY (group_id) REFERENCES USER_GROUPS(group_id), -- Foreign key referencing USER_GROUPS table
    FOREIGN KEY (page_id) REFERENCES PAGES(page_id), -- Foreign key referencing PAGES table
    FOREIGN KEY (user_timeline_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- TEXT_POSTS table: Stores text-specific posts
CREATE TABLE TEXT_POSTS (
    post_id INT PRIMARY KEY,                       -- Unique identifier for the post (same as in POSTS)
    post_text TEXT NOT NULL,                       -- Content of the text post
    FOREIGN KEY (post_id) REFERENCES POSTS(post_id) -- Foreign key referencing POSTS table
);

-- IMAGE_VIDEO_POSTS table: Stores image and video posts
CREATE TABLE IMAGE_VIDEO_POSTS (
    post_id INT PRIMARY KEY,                       -- Unique identifier for the post (same as in POSTS)
    post_blob BLOB NOT NULL,                       -- Binary data for images/videos
    FOREIGN KEY (post_id) REFERENCES POSTS(post_id) -- Foreign key referencing POSTS table
);

-- COMMENTS table: Stores comments on posts
CREATE TABLE COMMENTS (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each comment
    post_id INT,                                   -- Post ID that the comment is related to
    commenter_id INT,                             -- User ID of the commenter
    comment_text TEXT NOT NULL,                    -- Content of the comment
    type_of_comment VARCHAR(50),                   -- Type of the comment (e.g., text, image)
    is_deleted BOOLEAN DEFAULT 0,                 -- Soft delete flag for logical deletion
    FOREIGN KEY (post_id) REFERENCES POSTS(post_id),   -- Foreign key referencing POSTS table
    FOREIGN KEY (commenter_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- REPLIES table: Stores replies to comments
CREATE TABLE REPLIES (
    reply_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for each reply
    parent_comment_id INT,                         -- Comment ID that this reply is related to
    replied_by_id INT,                             -- User ID of the person who replied
    reply_text TEXT NOT NULL,                      -- Content of the reply
    is_deleted BOOLEAN DEFAULT 0,                  -- Soft delete flag for logical deletion
    FOREIGN KEY (parent_comment_id) REFERENCES COMMENTS(comment_id),  -- Foreign key referencing COMMENTS table
    FOREIGN KEY (replied_by_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- LIKES table: Stores likes/reactions on posts or comments
CREATE TABLE LIKES (
    like_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each like
    like_on_id INT NOT NULL,                       -- ID of the post or comment being liked
    like_on_type VARCHAR(50) NOT NULL,             -- Type of item being liked (post or comment)
    liked_by_id INT,                              -- User ID who liked the item
    reaction_type VARCHAR(50),                    -- Type of reaction (e.g., like, love, laugh)
    FOREIGN KEY (liked_by_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- USER_GROUP_RELATION table: Stores user-group membership details
CREATE TABLE USER_GROUP_RELATION (
    user_id INT,                                   -- User ID
    group_id INT,                                  -- Group ID
    joined_on_date DATE,                          -- Date when the user joined the group
    left_on_date DATE,                            -- Date when the user left the group (if applicable)
    active_or_passive_member BOOLEAN,             -- Indicates if the user is an active or passive member
    PRIMARY KEY(user_id, group_id),               -- Composite primary key (user_id, group_id)
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),  -- Foreign key referencing USERS table
    FOREIGN KEY (group_id) REFERENCES USER_GROUPS(group_id)  -- Foreign key referencing USER_GROUPS table
);

-- USER_PAGE_RELATION table: Stores user-page follow details
CREATE TABLE USER_PAGE_RELATION (
    user_id INT,                                   -- User ID
    page_id INT,                                   -- Page ID
    followed_on DATE,                             -- Date when the user followed the page
    unfollowed_on DATE,                           -- Date when the user unfollowed the page (if applicable)
    active_or_passive_member BOOLEAN,             -- Indicates if the user is an active or passive follower
    PRIMARY KEY(user_id, page_id),                -- Composite primary key (user_id, page_id)
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),  -- Foreign key referencing USERS table
    FOREIGN KEY (page_id) REFERENCES PAGES(page_id)  -- Foreign key referencing PAGES table
);

-- FRIEND_LIST table: Stores friendship relations between users
CREATE TABLE FRIEND_LIST (
    user_id INT,                                  -- User ID
    friend_id INT,                                -- Friend's User ID
    PRIMARY KEY(user_id, friend_id),              -- Composite primary key (user_id, friend_id)
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),  -- Foreign key referencing USERS table
    FOREIGN KEY (friend_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- MESSAGE_THREADS table: Stores details of message threads
CREATE TABLE MESSAGE_THREADS (
    thread_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each message thread
    thread_name VARCHAR(100),                      -- Optional name for the thread
    created_by INT,                               -- User ID who created the thread
    created_on DATE,                              -- Date when the thread was created
    FOREIGN KEY (created_by) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- MESSAGES table: Stores individual messages
CREATE TABLE MESSAGES (
    message_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each message
    thread_id INT,                                -- Thread ID where the message belongs
    sender_id INT,                                -- User ID who sent the message
    receiver_id INT,                              -- User ID who received the message
    message_text TEXT NOT NULL,                   -- Content of the message
    sent_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp of when the message was sent
    FOREIGN KEY (thread_id) REFERENCES MESSAGE_THREADS(thread_id),  -- Foreign key referencing MESSAGE_THREADS table
    FOREIGN KEY (sender_id) REFERENCES USERS(user_id),  -- Foreign key referencing USERS table
    FOREIGN KEY (receiver_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- MESSAGE_THREAD_PARTICIPANTS table: Stores users participating in message threads
CREATE TABLE MESSAGE_THREAD_PARTICIPANTS (
    thread_id INT,                                -- Thread ID
    user_id INT,                                  -- User ID
    joined_on DATE,                              -- Date when the user joined the thread
    PRIMARY KEY(thread_id, user_id),            -- Composite primary key (thread_id, user_id)
    FOREIGN KEY (thread_id) REFERENCES MESSAGE_THREADS(thread_id),  -- Foreign key referencing MESSAGE_THREADS table
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)  -- Foreign key referencing USERS table
);

-- Indexes for performance optimization
CREATE INDEX idx_user_id ON USERS(user_id);             -- Index on USERS table for user_id
CREATE INDEX idx_post_id ON POSTS(post_id);             -- Index on POSTS table for post_id
CREATE INDEX idx_group_id ON USER_GROUPS(group_id);     -- Index on USER_GROUPS table for group_id
CREATE INDEX idx_page_id ON PAGES(page_id);             -- Index on PAGES table for page_id


-- DATABASE FOR ABOVE SCHEMA 
-- Inserting data into USERS table 
INSERT INTO USERS (user_name, email, password, DOB, gender)
VALUES
('Alice', 'alice@example.com', 'password1', '1990-05-12', 'F'),
('Bob', 'bob@example.com', 'password2', '1985-08-23', 'M'),
('Charlie', 'charlie@example.com', 'password3', '1992-11-30', 'M'),
('David', 'david@example.com', 'password4', '1995-01-15', 'M'),
('Eva', 'eva@example.com', 'password5', '1988-04-07', 'F'),
('Frank', 'frank@example.com', 'password6', '1993-09-12', 'M'),
('Grace', 'grace@example.com', 'password7', '1989-02-28', 'F'),
('Henry', 'henry@example.com', 'password8', '1994-06-19', 'M'),
('Ivy', 'ivy@example.com', 'password9', '1991-07-21', 'F'),
('Jack', 'jack@example.com', 'password10', '1990-03-14', 'M'),
('Kara', 'kara@example.com', 'password11', '1986-05-25', 'F'),
('Leo', 'leo@example.com', 'password12', '1984-10-10', 'M'),
('Mia', 'mia@example.com', 'password13', '1992-02-03', 'F'),
('Nathan', 'nathan@example.com', 'password14', '1995-11-05', 'M'),
('Olivia', 'olivia@example.com', 'password15', '1987-12-17', 'F'),
('Paul', 'paul@example.com', 'password16', '1989-03-09', 'M'),
('Quinn', 'quinn@example.com', 'password17', '1993-05-29', 'M'),
('Rachel', 'rachel@example.com', 'password18', '1991-07-10', 'F'),
('Sam', 'sam@example.com', 'password19', '1988-08-02', 'M'),
('Tina', 'tina@example.com', 'password20', '1990-12-13', 'F');

-- Inserting data into USER_GROUPS table 
INSERT INTO USER_GROUPS (group_name, group_details, admin)
VALUES
('Sports Enthusiasts', 'Group for people who love sports', 1),
('Book Lovers', 'A group for book readers', 2),
('Movie Buffs', 'A group for movie discussions', 3),
('Travelers', 'Share travel experiences', 4),
('Music Fans', 'A group for music lovers', 5),
('Foodies', 'Discuss delicious food', 6),
('Tech Geeks', 'Latest tech trends', 7),
('Fitness Group', 'Get fit and healthy', 8),
('Gaming Zone', 'Gaming discussions', 9),
('Photographers', 'Share photography tips', 10),
('Artists Hub', 'Art and creativity group', 11),
('Nature Lovers', 'Explore nature', 12),
('Pet Owners', 'Discuss pet care', 13),
('Business Minds', 'Business and entrepreneurship', 14),
('Coding Experts', 'Share coding knowledge', 15),
('Auto Fans', 'Car and bike lovers', 16),
('Environment Warriors', 'Talk about environment protection', 17),
('Fashionistas', 'Latest fashion trends', 18),
('Investors', 'Discuss investments', 19),
('Bloggers', 'Share blogging tips', 20);

-- Inserting data into PAGES table 
INSERT INTO PAGES (page_name, page_details, created_by_id)
VALUES
('Healthy Living', 'Tips for a healthy lifestyle', 1),
('Adventure Diaries', 'Share your adventure stories', 2),
('Tech News', 'Latest technology updates', 3),
('Movie Reviews', 'Reviews and ratings of latest movies', 4),
('Food Recipes', 'Delicious recipes to try', 5),
('Photography Tips', 'Improve your photography skills', 6),
('Travel Guides', 'Explore the world with travel guides', 7),
('Art Showcase', 'A gallery for artists', 8),
('Gaming News', 'Latest news in the gaming world', 9),
('Fitness Tips', 'Stay fit with expert advice', 10),
('Book Reviews', 'Reviews of bestsellers', 11),
('Auto World', 'All about cars and bikes', 12),
('Fashion Trends', 'Stay updated on fashion', 13),
('Pet Care', 'Tips for taking care of pets', 14),
('Business Growth', 'Tips for entrepreneurs', 15),
('Coding Help', 'Programming tips and tricks', 16),
('Nature Conservation', 'Protect nature and wildlife', 17),
('Music Lovers', 'Share and discuss music', 18),
('Investor Tips', 'Investment advice for beginners', 19),
('Blogger World', 'Tips for successful blogging', 20);

-- Inserting data into POSTS table
INSERT INTO POSTS (author_id, group_id, page_id, user_timeline_id, post_type)
VALUES
(1, 1, NULL, NULL, 'text'),
(2, 2, NULL, NULL, 'image'),
(3, NULL, 1, NULL, 'text'),
(4, 3, NULL, NULL, 'video'),
(5, NULL, 2, NULL, 'text'),
(6, NULL, 3, NULL, 'image'),
(7, 4, NULL, NULL, 'text'),
(8, NULL, 4, NULL, 'video'),
(9, 5, NULL, NULL, 'image'),
(10, NULL, 5, NULL, 'text'),
(11, NULL, NULL, 1, 'text'),
(12, 6, NULL, NULL, 'video'),
(13, NULL, 6, NULL, 'text'),
(14, NULL, 7, NULL, 'image'),
(15, NULL, NULL, 2, 'text'),
(16, 7, NULL, NULL, 'video'),
(17, NULL, 8, NULL, 'image'),
(18, NULL, 9, NULL, 'text'),
(19, 8, NULL, NULL, 'text'),
(20, NULL, 10, NULL, 'video');

-- Inserting data into TEXT_POSTS table
INSERT INTO TEXT_POSTS (post_id, post_text)
VALUES
(1, 'A healthy lifestyle is key to happiness'),
(3, 'Technology is advancing at a fast pace'),
(5, 'Adventure is out there! Let\'s explore.'),
(7, 'Join the fitness group and get healthy!'),
(10, 'Photography is a beautiful art.'),
(11, 'Coding can be fun and creative.'),
(13, 'Let\'s share some tips about coding.'),
(15, 'Books open up a world of imagination.'),
(18, 'Nature is our biggest asset, protect it.'),
(19, 'Discuss your fitness journey with us.');

-- Inserting data into IMAGE_VIDEO_POSTS table
INSERT INTO IMAGE_VIDEO_POSTS (post_id, post_blob)
VALUES
(2, 'IMAGE BLOB DATA HERE'),
(4, 'VIDEO BLOB DATA HERE'),
(6, 'IMAGE BLOB DATA HERE'),
(8, 'VIDEO BLOB DATA HERE'),
(9, 'IMAGE BLOB DATA HERE'),
(12, 'VIDEO BLOB DATA HERE'),
(14, 'IMAGE BLOB DATA HERE'),
(16, 'VIDEO BLOB DATA HERE'),
(17, 'IMAGE BLOB DATA HERE'),
(20, 'VIDEO BLOB DATA HERE');

-- Inserting data into COMMENTS table
INSERT INTO COMMENTS (post_id, commenter_id, comment_text, type_of_comment)
VALUES
(1, 2, 'Great post about healthy living!', 'text'),
(2, 3, 'Awesome picture!', 'text'),
(3, 4, 'Very informative post', 'text'),
(4, 5, 'Cool video!', 'text'),
(5, 6, 'I love adventures', 'text'),
(6, 7, 'Great shot!', 'text'),
(7, 8, 'I agree with your point', 'text'),
(8, 9, 'Amazing video!', 'text'),
(9, 10, 'Nice photo!', 'text'),
(10, 11, 'Beautiful!', 'text');

-- Inserting data into REPLIES table
INSERT INTO REPLIES (parent_comment_id, replied_by_id, reply_text)
VALUES
(1, 3, 'Thank you!'),
(2, 4, 'Glad you liked it!'),
(3, 5, 'Thanks for the feedback!'),
(4, 6, 'Glad you enjoyed it!'),
(5, 7, 'I agree!'),
(6, 8, 'Thank you!'),
(7, 9, 'I appreciate it!'),
(8, 10, 'Thanks!'),
(9, 11, 'I\'m happy you liked it!'),
(10, 12, 'Thanks a lot!');

-- Inserting data into LIKES table
INSERT INTO LIKES (like_on_id, like_on_type, liked_by_id)
VALUES
(1, 'post', 3),
(2, 'post', 4),
(3, 'post', 5),
(4, 'post', 6),
(5, 'post', 7),
(6, 'post', 8),
(7, 'post', 9),
(8, 'post', 10),
(9, 'post', 11),
(10, 'post', 12),
(1, 'comment', 3),
(2, 'comment', 4),
(3, 'comment', 5),
(4, 'comment', 6),
(5, 'comment', 7),
(6, 'comment', 8),
(7, 'comment', 9),
(8, 'comment', 10),
(9, 'comment', 11),
(10, 'comment', 12);
