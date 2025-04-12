# Youtube-Exploration-Using--SQL
Objective:
To perform in-depth SQL-based data analysis on a simulated YouTube dataset. The goal is to uncover insights related to user engagement, video performance, subscriber trends, and content popularity by writing optimized SQL queries.

Overview:
This project simulates a mini YouTube ecosystem through interconnected datasets that represent users, channels, videos, genres, subscriptions, and reactions (likes/dislikes). It showcases your ability to handle real-world business use cases using SQL for data-driven decision-making.

Dataset Description:
The project includes the following CSV files:

channel.csv
Contains details of YouTube channels.

Fields: channel_id, name, created_date

user.csv
Represents platform users.

Fields: user_id, username, email, country, joined_date

channel_user.csv
Tracks user subscriptions to channels.

Fields: user_id, channel_id, subscribed_datetime

video.csv
Stores video-level information.

Fields: video_id, channel_id, name, published_datetime, no_of_views

user_likes.csv
Captures user interactions (likes/dislikes) on videos.

Fields: user_id, video_id, reaction_type, reacted_at

genre.csv
Represents different video genres.

Fields: genre_id, genre_type

video_genre.csv
Links videos with one or more genres.

Fields: video_id, genre_id

Key SQL Concepts Covered:
Joins (INNER, LEFT)

Filtering and Aggregation

Grouping and HAVING Clauses

Subqueries and Nested Queries

Date functions and formatting

Ordering and Limiting Results

DISTINCT and COUNT operations

Example Use Cases (Queries Implemented):
Top 10 channels by subscribers in 2018

Monthly subscriber growth for a specific channel

Channels with the highest number of videos

Most liked videos by Indian users

Users who liked a channel but are not subscribed

Peak engagement hours for specific genres

Channels with at least 5 videos in 2018

Top genres by number of likes

Active users who performed over 50 likes

Users who liked but avoided specific videos

