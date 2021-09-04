USE `es_extended`;

ALTER TABLE `users` ADD COLUMN `bixbi_tag` longtext COLLATE utf8mb4_bin DEFAULT '{"time":0,"reason":""}';

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('tracker', 'Tracker', 1, 0, 1),
	('trackertag', 'Tracker Tag', 1, 0, 1)
	('usb_trackertag', 'Tracker Tag Remover', 1, 0, 1);