
-- YouTube SQL Project

-- 1. Top 10 channels by number of subscribers in 2018
SELECT
  channel_user.channel_id,
  channel.name AS channel_name,
  COUNT(*) AS no_of_subscribers
FROM
  channel
  INNER JOIN channel_user ON channel.channel_id = channel_user.channel_id
WHERE
  CAST(STRFTIME('%Y', subscribed_datetime) AS INTEGER) = 2018
GROUP BY
  channel.name
ORDER BY
  no_of_subscribers DESC,
  channel_name ASC
LIMIT 10;

-- 2. Number of users reached by a specific channel (channel_id = 352)
SELECT
  COUNT(DISTINCT user_likes.user_id) AS no_of_users_reached
FROM
  user_likes
  INNER JOIN video ON user_likes.video_id = video.video_id
WHERE
  video.channel_id = 352
  AND user_likes.reaction_type LIKE 'LIKE';

-- 3. Subscriber count per channel (all-time)
SELECT
  channel.channel_id,
  channel.name AS channel_name,
  COUNT(user_id) AS no_of_subscribers
FROM
  channel
  LEFT JOIN channel_user ON channel.channel_id = channel_user.channel_id
GROUP BY
  channel.name
ORDER BY
  no_of_subscribers DESC,
  channel_name ASC;

-- 4. Number of videos by 'News for you' in 2018
SELECT
  COUNT(*) AS no_of_videos
FROM
  video
  INNER JOIN channel ON video.channel_id = channel.channel_id
WHERE
  channel.name LIKE 'News for you'
  AND CAST(STRFTIME('%Y', published_datetime) AS INTEGER) = 2018;

-- 5. Monthly subscriber count for 'Taylor Swift' in 2018
SELECT
  CAST(STRFTIME('%m', subscribed_datetime) AS INTEGER) AS month_in_2018,
  COUNT(*) AS subscribers_per_month
FROM
  channel_user
  INNER JOIN channel ON channel_user.channel_id = channel.channel_id
WHERE
  channel.name LIKE 'Taylor Swift'
  AND CAST(STRFTIME('%Y', subscribed_datetime) AS INTEGER) = 2018
GROUP BY
  month_in_2018;

-- 6. Number of videos per channel
SELECT
  channel.name AS channel_name,
  COUNT(video.video_id) AS no_of_videos
FROM
  channel
  LEFT JOIN video ON channel.channel_id = video.channel_id
GROUP BY
  channel.channel_id
ORDER BY
  channel.name ASC;

-- 7. Channels with 5 or more videos published in 2018
SELECT
  channel.channel_id,
  channel.name AS channel_name,
  COUNT(*) AS no_of_videos
FROM
  channel
  INNER JOIN video ON channel.channel_id = video.channel_id
WHERE
  CAST(STRFTIME('%Y', published_datetime) AS INTEGER) = 2018
GROUP BY
  channel.channel_id
HAVING
  no_of_videos >= 5
ORDER BY
  channel.channel_id;

-- 8. User reactions (like/dislike) for channel_id 366
SELECT
  user_likes.user_id,
  COUNT(*) AS no_of_reactions
FROM
  user_likes
  INNER JOIN video ON user_likes.video_id = video.video_id
WHERE
  video.channel_id = 366
  AND user_likes.reaction_type IN ('LIKE', 'DISLIKE')
GROUP BY
  user_likes.user_id
ORDER BY
  no_of_reactions DESC,
  user_likes.user_id ASC;

-- 9. Videos with above-average views
SELECT
  video.name,
  video.no_of_views
FROM
  video
WHERE
  video.no_of_views > (
    SELECT AVG(no_of_views) FROM video
  )
ORDER BY
  video.name ASC;

-- 10. Users who liked channel_id 364 but not video_id 1005
SELECT DISTINCT
  user_likes.user_id
FROM
  user_likes
  INNER JOIN video ON user_likes.video_id = video.video_id
WHERE
  video.channel_id = 364
  AND user_likes.reaction_type = 'LIKE'
  AND user_likes.user_id NOT IN (
    SELECT DISTINCT user_likes.user_id
    FROM user_likes
    INNER JOIN video ON user_likes.video_id = video.video_id
    WHERE
      user_likes.reaction_type = 'LIKE'
      AND user_likes.video_id = 1005
  )
ORDER BY
  user_likes.user_id ASC;

-- 11. Videos with genre_id 201 and 202 sorted by views
SELECT DISTINCT
  video.name AS video_name,
  video.no_of_views
FROM
  video
  JOIN video_genre ON video.video_id = video_genre.video_id
WHERE
  video.video_id IN (
    SELECT video_id FROM video_genre WHERE genre_id = 201
  )
  AND video.video_id IN (
    SELECT video_id FROM video_genre WHERE genre_id = 202
  )
ORDER BY
  video.no_of_views DESC,
  video.name ASC
LIMIT 5;

-- 12. Peak hour of engagement for genre_id 202
SELECT
  CAST(STRFTIME('%H', reacted_at) AS INTEGER) AS hour_of_engagement,
  COUNT(*) AS no_of_likes
FROM
  user_likes
  JOIN video ON user_likes.video_id = video.video_id
  JOIN video_genre ON video.video_id = video_genre.video_id
WHERE
  user_likes.reaction_type = 'LIKE'
  AND video_genre.genre_id = 202
GROUP BY
  hour_of_engagement
ORDER BY
  no_of_likes DESC
LIMIT 1;

-- 13. Top 5 GAMING genre videos by views
SELECT
  video.name AS video_name,
  video.no_of_views
FROM
  video
  INNER JOIN video_genre ON video.video_id = video_genre.video_id
  LEFT JOIN genre ON video_genre.genre_id = genre.genre_id
WHERE
  genre.genre_type = 'GAMING'
ORDER BY
  video.no_of_views DESC,
  video_name ASC
LIMIT 5;

-- 14. Users with 50+ likes overall
SELECT
  user_id AS active_user_id,
  COUNT(*) AS no_of_likes
FROM
  user_likes
WHERE
  reaction_type = 'LIKE'
GROUP BY
  active_user_id
HAVING
  no_of_likes >= 50;

-- 15. Users with 5+ likes on 'Tedx' channel
SELECT
  user_likes.user_id AS active_user_id,
  COUNT(*) AS no_of_likes
FROM
  user_likes
  INNER JOIN video ON user_likes.video_id = video.video_id
  LEFT JOIN channel ON video.channel_id = channel.channel_id
WHERE
  user_likes.reaction_type = 'LIKE'
  AND channel.name = 'Tedx'
GROUP BY
  active_user_id
HAVING
  no_of_likes >= 5
ORDER BY
  no_of_likes DESC,
  active_user_id ASC;

-- 16. Potential users who liked 2+ videos from channel_id 352 and are not subscribed
SELECT DISTINCT
  user_likes.user_id AS potential_user_id,
  COUNT(*) AS no_of_likes
FROM
  user_likes
  INNER JOIN video ON user_likes.video_id = video.video_id
WHERE
  user_likes.reaction_type = 'LIKE'
  AND video.channel_id = 352
  AND user_likes.user_id NOT IN (
    SELECT channel_user.user_id
    FROM channel_user
    WHERE channel_user.channel_id = 352
  )
GROUP BY
  potential_user_id
HAVING
  COUNT(video.video_id) >= 2
ORDER BY
  no_of_likes DESC,
  potential_user_id ASC;

-- 17. Top 5 genres by number of likes (if genre_id > 2)
SELECT
  genre.genre_id,
  genre.genre_type,
  COUNT(user_likes.reaction_type) AS no_of_likes
FROM
  genre
  INNER JOIN video_genre ON genre.genre_id = video_genre.genre_id
  INNER JOIN user_likes ON video_genre.video_id = user_likes.video_id
WHERE
  user_likes.reaction_type = 'LIKE'
  AND genre.genre_id > 2
GROUP BY
  genre.genre_id
ORDER BY
  no_of_likes DESC,
  genre_type ASC
LIMIT 5;

-- 18. Top 3 genres liked by Indian users in 2018
SELECT
  video_genre.genre_id,
  COUNT(*) AS no_of_likes
FROM
  user_likes
  INNER JOIN video_genre ON user_likes.video_id = video_genre.video_id
  INNER JOIN user ON user_likes.user_id = user.user_id
WHERE
  user.country = 'INDIA'
  AND STRFTIME('%Y', reacted_at) = '2018'
  AND user_likes.reaction_type = 'LIKE'
GROUP BY
  video_genre.genre_id
ORDER BY
  no_of_likes DESC,
  genre_id ASC
LIMIT 3;
