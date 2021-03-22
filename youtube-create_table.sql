
DROP TABLE IF EXISTS `channel_users`;

CREATE TABLE `channel_users` (
  `channel_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`channel_id`,`user_id`),
  KEY `user_id_users_id_fk` (`user_id`),
  CONSTRAINT `channel_id_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`),
  CONSTRAINT `user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `channels`;

CREATE TABLE `channels` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` int unsigned NOT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='??????';

DROP TABLE IF EXISTS `comments`;

CREATE TABLE `comments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` int unsigned NOT NULL,
  `target_id` int unsigned NOT NULL,
  `target_comment_id` int unsigned NOT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `comments_from_user_id_user_id_fk` (`from_user_id`),
  CONSTRAINT `comments_from_user_id_user_id_fk` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `likes`;

CREATE TABLE `likes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `target_id` int unsigned NOT NULL,
  `target_likes_id` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `target_id` (`target_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `profiles`;

CREATE TABLE `profiles` (
  `user_id` int unsigned NOT NULL,
  `gender` enum('M','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `city` varchar(130) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(130) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  CONSTRAINT `profiles_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `subscription_statuses`;

CREATE TABLE `subscription_statuses` (
  `subscription_id` int unsigned NOT NULL,
  `notifications` tinyint(1) DEFAULT '0',
  `sponsor` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `subscriptions`;

CREATE TABLE `subscriptions` (
  `user_id` int unsigned NOT NULL,
  `channel_id` int unsigned NOT NULL,
  `subscription_status_id` int unsigned NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`channel_id`),
  KEY `sub_channel_id_channels_id_fk` (`channel_id`),
  KEY `subscriptions_subscription_status_id_fk` (`subscription_status_id`),
  CONSTRAINT `sub_channel_id_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`),
  CONSTRAINT `sub_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `subscriptions_subscription_status_id_fk` FOREIGN KEY (`subscription_status_id`) REFERENCES `subscription_statuses` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `target`;

CREATE TABLE `target` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` enum('comments','video_posts') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pseudonym` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pseudonym` (`pseudonym`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `video_posts`;

CREATE TABLE `video_posts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `channel_id` int unsigned DEFAULT NULL,
  `head` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `is_public` tinyint(1) DEFAULT '1',
  `is_archived` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `video_post_user_id_fk` (`user_id`),
  KEY `video_post_channel_id_fk` (`channel_id`),
  CONSTRAINT `video_post_channel_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`),
  CONSTRAINT `video_post_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `video_posts_chk_1` CHECK (json_valid(`metadata`))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `video_profiles`;

CREATE TABLE `video_profiles` (
  `video_posts_id` int unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`video_posts_id`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `video_profile_video_post_id_fk` FOREIGN KEY (`video_posts_id`) REFERENCES `video_posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `video_qualities`;

CREATE TABLE `video_qualities` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `video_profiles_id` int unsigned NOT NULL,
  `size` int NOT NULL,
  `quality` enum('144p','240p','360p','480p','720p','1080p') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `video_qual_video_prof_fk` (`video_profiles_id`),
  CONSTRAINT `video_qual_video_prof_fk` FOREIGN KEY (`video_profiles_id`) REFERENCES `video_profiles` (`video_posts_id`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `video_subtitles`;

CREATE TABLE `video_subtitles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `video_profiles_id` int unsigned NOT NULL,
  `size` int NOT NULL,
  `subtitle` enum('NOT','ENG','RUS') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `video_sub_video_prof_fk` (`video_profiles_id`),
  CONSTRAINT `video_sub_video_prof_fk` FOREIGN KEY (`video_profiles_id`) REFERENCES `video_profiles` (`video_posts_id`)
) ENGINE=InnoDB AUTO_INCREMENT=304 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



UPDATE users SET updated_at = NOW() WHERE updated_at < created_at; 
UPDATE profiles SET updated_at = NOW() WHERE updated_at < created_at;    
UPDATE video_qualities SET updated_at = NOW() WHERE updated_at < created_at; 
UPDATE video_posts SET updated_at = NOW() WHERE updated_at < created_at; 
UPDATE video_profiles SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE video_subtitles SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE subscriptions SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE subscription_statuses SET updated_at = NOW() WHERE updated_at < created_at;
UPDATE channels SET updated_at = NOW() WHERE updated_at < created_at; 

UPDATE video_profiles SET name = CONCAT('http://Youtube.net/content/', name );

UPDATE video_qualities SET size = FLOOR(100 + (RAND() * 1000000)) WHERE quality = '144p';
UPDATE video_qualities SET size = FLOOR(200 + (RAND() * 1000000)) WHERE quality = '240p';
UPDATE video_qualities SET size = FLOOR(300 + (RAND() * 1000000)) WHERE quality = '360p';
UPDATE video_qualities SET size = FLOOR(400 + (RAND() * 1000000)) WHERE quality = '480p';
UPDATE video_qualities SET size = FLOOR(800 + (RAND() * 1000000)) WHERE quality = '720p';
UPDATE video_qualities SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE quality = '1080p';
UPDATE video_qualities SET size = FLOOR(100 + (RAND() * 1000000)) WHERE quality = '144p';


UPDATE video_subtitles SET size = 0 WHERE subtitle = 'NOT';

UPDATE video_posts SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');
 
ALTER TABLE video_posts MODIFY COLUMN metadata JSON;


CREATE UNIQUE INDEX users_email_uq ON users(email);
CREATE UNIQUE INDEX users_phone_uq ON users(phone);
CREATE INDEX user_name_user_last_name_idx ON users (first_name, last_name);

CREATE INDEX profiles_birthday_uq ON profiles(birthday);
CREATE INDEX profiles_country_profiles_city_idx ON profiles(country, city);

CREATE INDEX channels_name_uq ON channels(name);

CREATE INDEX video_posts_head_is_public_is_archived_idx ON video_posts(head, is_public, is_archived);


==============
mysqldump -u root -p youtube > youtube-dump.SQL
