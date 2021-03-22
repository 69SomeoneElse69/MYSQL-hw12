-- кто поставил больше лайков коментариям мужчины или женщины  
 SELECT profiles.gender ,count(likes.id) as total
 FROM likes
JOIN profiles
on profiles.user_id = likes.user_id and likes.target_likes_id = '2'
group by profiles.gender 
ORDER BY total desc;

-- количаство лайков видео у 10 самых молодых пользователей от других пользователей
select birthday, tipe, total 
FROM
(select birthday, likes.target_likes_id as tipe, count(likes.user_id) as total
from profiles
join likes
on likes.user_id = profiles.user_id and likes.target_likes_id = '1'
GROUP BY likes.user_id
ORDER BY birthday desc
limit 10) main_data
UNION ALL
SELECT null, "итого", sum(total)
from
(SELECT count(likes.user_id) as total
from profiles 
join likes
on likes.user_id = profiles.user_id and likes.target_likes_id = '1'
GROUP BY likes.user_id
ORDER BY birthday desc
limit 10) total_likes;


-- Запрос выводит следующие столбцы:
-- имя канала
-- самый молодой пользователь на канале
-- самый старший пользователь на канале
-- общее количество пользователей на канале
-- всего пользователей в системе
-- отношение в процентах 
-- (общее количество пользователей в группе /  всего пользователей в системе) * 100
SELECT DISTINCT 
  channels.name AS channel_name,
  FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) OVER w_channel_birthday_desc AS youngest,
  FIRST_VALUE(CONCAT_WS(" ", users.first_name, users.last_name)) OVER w_channel_birthday_asc AS oldest,
  COUNT(channel_users.user_id) OVER w_channel AS users_in_cannel,
  (SELECT COUNT(*) FROM users) AS users_total,
  COUNT(channel_users.user_id) OVER w_channel / (SELECT COUNT(*) FROM users) *100 AS '%%'
    FROM channels
      LEFT JOIN channel_users 
        ON channel_users.channel_id = channels.id
      LEFT JOIN users 
        ON channel_users.user_id = users.id
      LEFT JOIN profiles 
        ON profiles.user_id = users.id
      WINDOW w_channel AS (PARTITION BY channels.id),
             w_channel_birthday_desc AS (PARTITION BY channels.id ORDER BY profiles.birthday DESC),
             w_channel_birthday_asc AS (PARTITION BY channels.id ORDER BY profiles.birthday);


-- представление в котором выводятся имя пользователя в связке с названием поста и JSON.
CREATE OR REPLACE VIEW users_video_posts AS
SELECT
users.first_name AS name,
video_posts.head AS sign,
video_posts.metadata AS json
FROM
users
JOIN
video_posts
ON
video_posts.user_id = users.id;

select * from users_video_posts;

-- представление в котором выводится название канала, ссылка, субтитры и качество.
CREATE OR REPLACE VIEW channels_video_posts_subtitles_quality AS
select
channels .name as channel_name,
video_profiles.name AS link,
video_subtitles.subtitle as sub,
video_qualities.quality as qualities
FROM
video_posts
JOIN
channels
ON
channels.id = video_posts.channel_id
JOIN
video_profiles 
ON
video_profiles.video_posts_id = video_posts.id
JOIN
video_subtitles 
ON
video_subtitles.video_profiles_id = video_profiles.video_posts_id
JOIN
video_qualities
ON
video_qualities.video_profiles_id = video_profiles.video_posts_id;

select * from channels_video_posts_subtitles_quality;



-- тригеры с таблицей архивировакния
CREATE TABLE IF NOT EXISTS Logs (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    table_name varchar(50) NOT NULL,
    row_id INT UNSIGNED NOT NULL,
    row_name varchar(255)
) ENGINE = Archive;


CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "users", NEW.id, NEW.name);
END;

CREATE TRIGGER profiles_insert AFTER INSERT ON profiles
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "profiles", NEW.id, NEW.name);
END;

CREATE TRIGGER channels_inserts AFTER INSERT ON channels
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "channels", NEW.id, NEW.name);
END;

CREATE TRIGGER video_posts_inserts AFTER INSERT ON video_posts
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "video_posts", NEW.id, NEW.name);
END;

CREATE TRIGGER comments_inserts AFTER INSERT ON comments
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "comments", NEW.id, NEW.name);
END;