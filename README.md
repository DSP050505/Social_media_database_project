# Social Media Platform Database Schema

## Overview

This document provides a detailed description of the database schema for a social media platform. The schema is designed to handle users, groups, pages, posts, comments, likes, and messaging functionalities. The `schema.sql` file defines the structure of the database, while the `queries.sql` file contains example queries to interact with the data.

## Schema

### `schema.sql`

The `schema.sql` file sets up the database schema with the following tables:

#### `USERS`

- **Purpose**: Stores user information.
- **Columns**:
  - `user_id`: Unique identifier for each user (Primary Key).
  - `user_name`: User's display name.
  - `email`: User's email address (Unique).
  - `password`: User's hashed password.
  - `DOB`: User's date of birth.
  - `gender`: User's gender (e.g., M, F, O).
  - `is_deleted`: Soft delete flag to indicate if the user account is deleted.

#### `USER_GROUPS`

- **Purpose**: Stores information about user groups.
- **Columns**:
  - `group_id`: Unique identifier for each group (Primary Key).
  - `group_name`: Name of the group.
  - `group_details`: Details about the group.
  - `admin`: User ID of the group's admin (Foreign Key referencing `USERS`).
  - `is_deleted`: Soft delete flag for the group.

#### `PAGES`

- **Purpose**: Stores information about pages.
- **Columns**:
  - `page_id`: Unique identifier for each page (Primary Key).
  - `page_name`: Name of the page.
  - `page_details`: Details about the page.
  - `created_by_id`: User ID of the page creator (Foreign Key referencing `USERS`).
  - `is_deleted`: Soft delete flag for the page.

#### `POSTS`

- **Purpose**: Stores posts made by users.
- **Columns**:
  - `post_id`: Unique identifier for each post (Primary Key).
  - `author_id`: User ID of the post author (Foreign Key referencing `USERS`).
  - `group_id`: Group ID if the post is related to a group (Foreign Key referencing `USER_GROUPS`).
  - `page_id`: Page ID if the post is related to a page (Foreign Key referencing `PAGES`).
  - `user_timeline_id`: User ID if the post is related to a user timeline (Foreign Key referencing `USERS`).
  - `post_type`: Type of the post (e.g., text, image, video).
  - `is_deleted`: Soft delete flag for the post.

#### `TEXT_POSTS`

- **Purpose**: Stores text-specific posts.
- **Columns**:
  - `post_id`: Unique identifier for the post (Primary Key, Foreign Key referencing `POSTS`).
  - `post_text`: Content of the text post.

#### `IMAGE_VIDEO_POSTS`

- **Purpose**: Stores image and video posts.
- **Columns**:
  - `post_id`: Unique identifier for the post (Primary Key, Foreign Key referencing `POSTS`).
  - `post_blob`: Binary data for images or videos.

#### `COMMENTS`

- **Purpose**: Stores comments on posts.
- **Columns**:
  - `comment_id`: Unique identifier for each comment (Primary Key).
  - `post_id`: Post ID that the comment is related to (Foreign Key referencing `POSTS`).
  - `commenter_id`: User ID of the commenter (Foreign Key referencing `USERS`).
  - `comment_text`: Content of the comment.
  - `type_of_comment`: Type of the comment (e.g., text, image).
  - `is_deleted`: Soft delete flag for the comment.

#### `REPLIES`

- **Purpose**: Stores replies to comments.
- **Columns**:
  - `reply_id`: Unique identifier for each reply (Primary Key).
  - `parent_comment_id`: Comment ID that this reply is related to (Foreign Key referencing `COMMENTS`).
  - `replied_by_id`: User ID of the person who replied (Foreign Key referencing `USERS`).
  - `reply_text`: Content of the reply.
  - `is_deleted`: Soft delete flag for the reply.

#### `LIKES`

- **Purpose**: Stores likes/reactions on posts or comments.
- **Columns**:
  - `like_id`: Unique identifier for each like (Primary Key).
  - `like_on_id`: ID of the post or comment being liked.
  - `like_on_type`: Type of item being liked (post or comment).
  - `liked_by_id`: User ID who liked the item (Foreign Key referencing `USERS`).
  - `reaction_type`: Type of reaction (e.g., like, love, laugh).

#### `USER_GROUP_RELATION`

- **Purpose**: Stores user-group membership details.
- **Columns**:
  - `user_id`: User ID (Foreign Key referencing `USERS`).
  - `group_id`: Group ID (Foreign Key referencing `USER_GROUPS`).
  - `joined_on_date`: Date when the user joined the group.
  - `left_on_date`: Date when the user left the group (if applicable).
  - `active_or_passive_member`: Indicates if the user is an active or passive member.
  - **Primary Key**: Composite key (`user_id`, `group_id`).

#### `USER_PAGE_RELATION`

- **Purpose**: Stores user-page follow details.
- **Columns**:
  - `user_id`: User ID (Foreign Key referencing `USERS`).
  - `page_id`: Page ID (Foreign Key referencing `PAGES`).
  - `followed_on`: Date when the user followed the page.
  - `unfollowed_on`: Date when the user unfollowed the page (if applicable).
  - `active_or_passive_member`: Indicates if the user is an active or passive follower.
  - **Primary Key**: Composite key (`user_id`, `page_id`).

#### `FRIEND_LIST`

- **Purpose**: Stores friendship relations between users.
- **Columns**:
  - `user_id`: User ID (Foreign Key referencing `USERS`).
  - `friend_id`: Friend's User ID (Foreign Key referencing `USERS`).
  - **Primary Key**: Composite key (`user_id`, `friend_id`).

#### `MESSAGE_THREADS`

- **Purpose**: Stores details of message threads.
- **Columns**:
  - `thread_id`: Unique identifier for each message thread (Primary Key).
  - `thread_name`: Optional name for the thread.
  - `created_by`: User ID who created the thread (Foreign Key referencing `USERS`).
  - `created_on`: Date when the thread was created.

#### `MESSAGES`

- **Purpose**: Stores individual messages.
- **Columns**:
  - `message_id`: Unique identifier for each message (Primary Key).
  - `thread_id`: Thread ID where the message belongs (Foreign Key referencing `MESSAGE_THREADS`).
  - `sender_id`: User ID who sent the message (Foreign Key referencing `USERS`).
  - `receiver_id`: User ID who received the message (Foreign Key referencing `USERS`).
  - `message_text`: Content of the message.
  - `sent_on`: Timestamp of when the message was sent.

#### `MESSAGE_THREAD_PARTICIPANTS`

- **Purpose**: Stores users participating in message threads.
- **Columns**:
  - `thread_id`: Thread ID (Foreign Key referencing `MESSAGE_THREADS`).
  - `user_id`: User ID (Foreign Key referencing `USERS`).
  - `joined_on`: Date when the user joined the thread.
  - **Primary Key**: Composite key (`thread_id`, `user_id`).

### Indexes

Indexes are created to optimize the performance of queries involving these columns:

```sql
CREATE INDEX idx_user_id ON USERS(user_id);            -- Index on USERS table for user_id
CREATE INDEX idx_post_id ON POSTS(post_id);            -- Index on POSTS table for post_id
CREATE INDEX idx_group_id ON USER_GROUPS(group_id);    -- Index on USER_GROUPS table for group_id
CREATE INDEX idx_page_id ON PAGES(page_id);            -- Index on PAGES table for page_id
