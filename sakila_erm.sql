-- added table first_names, last_names, keytimes
--    names connect to actor, customer, staff
--    keytimes connect to every table with update time and to rental/return time
-- added connection of film_text to film using film_id



CREATE TABLE `actor` (
  `actor_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `fname_id` SMALLINT NOT NULL,
  `lname_id` SMALLINT NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `address` (
  `address_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(50) NOT NULL,
  `address2` VARCHAR(50) DEFAULT NULL,
  `district` VARCHAR(20) NOT NULL,
  `city_id` SMALLINT NOT NULL,
  `postal_code` VARCHAR(10) DEFAULT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `category` (
  `category_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(25) NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `city` (
  `city_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(50) NOT NULL,
  `country_id` SMALLINT NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `country` (
  `country_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(50) NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `first_names` (
  `fname_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `last_names` (
  `lname_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `customer` (
  `customer_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `store_id` TINYINT NOT NULL,
  `fname_id` SMALLINT NOT NULL,
  `lname_id` SMALLINT NOT NULL,
  `email` VARCHAR(50) DEFAULT NULL,
  `address_id` SMALLINT NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `create_date` DATETIME NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `film` (
  `film_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(128) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `release_year` YEAR DEFAULT NULL,
  `language_id` TINYINT NOT NULL,
  `original_language_id` TINYINT DEFAULT NULL,
  `rental_duration` TINYINT NOT NULL DEFAULT 3,
  `rental_rate` DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  `length` SMALLINT DEFAULT NULL,
  `replacement_cost` DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  `rating` ENUM ('G', 'PG', 'PG-13', 'R', 'NC-17') DEFAULT "G",
  `special_features` SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `film_actor` (
  `actor_id` SMALLINT NOT NULL,
  `film_id` SMALLINT NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `film_category` (
  `film_id` SMALLINT NOT NULL,
  `category_id` TINYINT NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `film_text` (
  `film_id` SMALLINT PRIMARY KEY NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT
);

CREATE TABLE `inventory` (
  `inventory_id` MEDIUMINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `film_id` SMALLINT NOT NULL,
  `store_id` TINYINT NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `language` (
  `language_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` CHAR(20) NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `payment` (
  `payment_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `customer_id` SMALLINT NOT NULL,
  `staff_id` TINYINT NOT NULL,
  `rental_id` INT DEFAULT NULL,
  `amount` DECIMAL(5,2) NOT NULL,
  `payment_date` DATETIME NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `rental` (
  `rental_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `rental_time_id` BIGINT NOT NULL,
  `inventory_id` MEDIUMINT NOT NULL,
  `customer_id` SMALLINT NOT NULL,
  `return_time_id` BIGINT NOT NULL,
  `staff_id` TINYINT NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `staff` (
  `staff_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `fname_id` SMALLINT NOT NULL,
  `lname_id` SMALLINT NOT NULL,
  `address_id` SMALLINT NOT NULL,
  `picture` BLOB DEFAULT NULL,
  `email` VARCHAR(50) DEFAULT NULL,
  `store_id` TINYINT NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `username` VARCHAR(16) NOT NULL,
  `password` VARCHAR(40) DEFAULT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `store` (
  `store_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `manager_staff_id` TINYINT NOT NULL,
  `address_id` SMALLINT NOT NULL,
  `update_id` BIGINT NOT NULL
);

CREATE TABLE `keytimes` (
  `time_id` BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `time_stamp` TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

ALTER TABLE `address` ADD CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `city` ADD CONSTRAINT `fk_city_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `customer` ADD CONSTRAINT `fk_customer_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `customer` ADD CONSTRAINT `fk_customer_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film` ADD CONSTRAINT `fk_film_language` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film` ADD CONSTRAINT `fk_film_language_original` FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_actor` ADD CONSTRAINT `fk_film_actor_actor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`actor_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_actor` ADD CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_category` ADD CONSTRAINT `fk_film_category_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_category` ADD CONSTRAINT `fk_film_category_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `inventory` ADD CONSTRAINT `fk_inventory_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `inventory` ADD CONSTRAINT `fk_inventory_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `payment` ADD CONSTRAINT `fk_payment_rental` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`rental_id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `payment` ADD CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `payment` ADD CONSTRAINT `fk_payment_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rental` ADD CONSTRAINT `fk_rental_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rental` ADD CONSTRAINT `fk_rental_inventory` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rental` ADD CONSTRAINT `fk_rental_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `staff` ADD CONSTRAINT `fk_staff_store` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `staff` ADD CONSTRAINT `fk_staff_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `store` ADD CONSTRAINT `fk_store_staff` FOREIGN KEY (`manager_staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `store` ADD CONSTRAINT `fk_store_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `first_names` ADD FOREIGN KEY (`fname_id`) REFERENCES `actor` (`fname_id`);

ALTER TABLE `first_names` ADD FOREIGN KEY (`fname_id`) REFERENCES `staff` (`fname_id`);

ALTER TABLE `last_names` ADD FOREIGN KEY (`lname_id`) REFERENCES `staff` (`lname_id`);

ALTER TABLE `last_names` ADD FOREIGN KEY (`lname_id`) REFERENCES `actor` (`lname_id`);

ALTER TABLE `last_names` ADD FOREIGN KEY (`lname_id`) REFERENCES `customer` (`lname_id`);

ALTER TABLE `first_names` ADD FOREIGN KEY (`fname_id`) REFERENCES `customer` (`fname_id`);

ALTER TABLE `film` ADD FOREIGN KEY (`film_id`) REFERENCES `film_text` (`film_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `language` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `category` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `film_category` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `actor` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `film_actor` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `staff` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `customer` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `rental` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `store` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `payment` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `country` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `city` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `address` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `inventory` (`update_id`);

ALTER TABLE `keytimes` ADD FOREIGN KEY (`time_id`) REFERENCES `film` (`update_id`);
