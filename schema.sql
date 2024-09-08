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
