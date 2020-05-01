-- suppose make a relation with the users table of ejabberd database
-- and perhaps an id field with auto_increment also may be adding an index lat, lon field 
-- this is a temporary structure , I was more focused on fixing IQ handler part.
CREATE TABLE `locations` (
  `user_id` varchar(255) NOT NULL,
  `lat` decimal(10,8) NOT NULL,
  `lon` decimal(11,8) NOT NULL,
  PRIMARY KEY (`user_id`)
);