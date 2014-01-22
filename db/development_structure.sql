CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `author` varchar(255) default NULL,
  `author_url` varchar(255) default NULL,
  `author_email` varchar(255) default NULL,
  `body` mediumtext NOT NULL,
  `user_ip` varchar(255) default NULL,
  `user_agent` varchar(255) default NULL,
  `referrer` varchar(255) default NULL,
  `item_id` int(11) NOT NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `c_item_id_idx` (`item_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `contact_requests` (
  `id` int(11) NOT NULL auto_increment,
  `sender` varchar(255) default NULL,
  `sender_email` varchar(255) default NULL,
  `body` mediumtext NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `items` (
  `id` int(11) NOT NULL auto_increment,
  `slug` varchar(255) default NULL,
  `title` text,
  `teaser` text,
  `body` mediumtext NOT NULL,
  `type` varchar(255) NOT NULL,
  `section_id` int(11) NOT NULL,
  `visible` tinyint(1) NOT NULL default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `i_slug_idx` (`slug`),
  KEY `i_visible_idx` (`visible`),
  KEY `i_slug_visible_idx` (`slug`,`visible`),
  KEY `i_section_idx` (`section_id`),
  KEY `i_section_visible_idx` (`section_id`,`visible`),
  FULLTEXT KEY `i_fulltext_idx` (`title`,`teaser`,`body`)
) ENGINE=MyISAM AUTO_INCREMENT=107 DEFAULT CHARSET=utf8;

CREATE TABLE `media` (
  `id` int(11) NOT NULL auto_increment,
  `filename` varchar(255) NOT NULL,
  `type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `a_filename_idx` (`filename`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sections` (
  `id` int(11) NOT NULL auto_increment,
  `slug` varchar(255) NOT NULL,
  `name` text NOT NULL,
  `page_size` int(11) NOT NULL default '0',
  `order` int(11) NOT NULL default '0',
  `on_home_page` tinyint(1) NOT NULL default '1',
  `in_navigation` tinyint(1) NOT NULL default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `s_slug_idx` (`slug`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `password_salt` varchar(8) NOT NULL,
  `password_hash` varchar(64) NOT NULL,
  `last_login` datetime default NULL,
  `auth_token` varchar(64) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `u_username_idx` (`username`),
  UNIQUE KEY `u_auth_token_idx` (`auth_token`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');