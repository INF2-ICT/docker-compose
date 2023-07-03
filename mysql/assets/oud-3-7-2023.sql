-- Adminer 4.8.1 MySQL 5.5.5-10.11.3-MariaDB-1:10.11.3+maria~ubu2204 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DELIMITER ;;

DROP PROCEDURE IF EXISTS `add_cash`;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_cash`(IN `amount` DOUBLE(8,2), IN `description` VARCHAR(100), IN `DateAndTime` datetime)
INSERT INTO `cash_flow`(`amount`, `description`, `DateAndTime`) VALUES (amount, description, DateAndTime);;

DROP PROCEDURE IF EXISTS `add_MT940`;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_MT940`(IN `reference` VARCHAR(16), IN `account` VARCHAR(33), IN `statementNR` VARCHAR(5), IN `sequenceNR` VARCHAR(5), IN `type` ENUM('C','D'), IN `date` DATE, IN `currency` VARCHAR(3), IN `start` DOUBLE(17,2), IN `final` DOUBLE(17,2))
INSERT INTO `statements`(`transaction_reference`, `account`, `statement_number`, `sequence_number`, `transaction_type`, `date`, `currency`, `starting_balance`, `final_balance`) VALUES (reference, account, statementNR, sequenceNR, type, date, currency, start, final);;

DROP PROCEDURE IF EXISTS `add_transaction`;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_transaction`(IN `reference` VARCHAR(16), IN `value_date` DATE, IN `entry_date` DATE, IN `type` ENUM('C','D'), IN `fund_code` VARCHAR(4), IN `amount` DOUBLE(17,2), IN `id_code` VARCHAR(4), IN `owner_ref` VARCHAR(35), IN `benef_ref` VARCHAR(35), IN `supplementary` VARCHAR(34), IN `line1` VARCHAR(65), IN `line2` VARCHAR(65), IN `line3` VARCHAR(65), IN `line4` VARCHAR(65), IN `line5` VARCHAR(65), IN `line6` VARCHAR(65))
INSERT INTO `transaction`(`transaction_reference`, `value_date`, `entry_date`, `transaction_type`, `fund_code`, `amount_in_euro`, `identifier_code`, `owner_reference`, `beneficiary_reference`, `supplementary_details`, `line1`, `line2`, `line3`, `line4`, `line5`, `line6`) VALUES (reference, value_date, entry_date, type, fund_code, amount, id_code, owner_ref, benef_ref, supplementary, line1, line2, line3, line4, line5, line6);;

DROP PROCEDURE IF EXISTS `get_single_transaction`;;
CREATE PROCEDURE `get_single_transaction`(IN `input_id` int)
BEGIN
    SELECT 
        `transaction`.`ID` AS `id`,
        `transaction`.`transaction_reference` AS `transaction_reference`,
        `transaction`.`user_comment` AS `user_comment`,
        `transaction`.`value_date` AS `value_date`,
        `transaction`.`transaction_type` AS `transaction_type`,
        `transaction`.`amount_in_euro` AS `amount_in_euro`,
        `transaction`.`identifier_code` AS `identifier_code`,
        `transaction`.`owner_reference` AS `owner_reference`
    FROM 
        `transaction`
    WHERE 
        `transaction`.`ID` = input_id;
END;;

DROP PROCEDURE IF EXISTS `insert_transaction`;;
CREATE PROCEDURE `insert_transaction`(
    IN amount_in_euro DECIMAL(17,2),
    IN transaction_reference VARCHAR(16),
    IN value_date DATE,
    IN transaction_type CHAR(1),
    IN user_comment VARCHAR(500)
)
BEGIN
    INSERT INTO `statements` (
        `transaction_reference`,
        `account`,
        `statement_number`,
        `sequence_number`,
        `transaction_type`,
        `date`,
        `currency`,
        `starting_balance`,
        `final_balance`
    )
    VALUES (
        transaction_reference,
        '',
        '',
        '',
        transaction_type,
        NOW(),
        '',
        amount_in_euro,
        amount_in_euro
    );

    INSERT INTO `transaction` (
        `transaction_reference`,
        `value_date`,
        `entry_date`,
        `transaction_type`,
        `fund_code`,
        `amount_in_euro`,
        `identifier_code`,
        `owner_reference`,
        `beneficiary_reference`,
        `supplementary_details`,
        `line1`,
        `line2`,
        `line3`,
        `line4`,
        `line5`,
        `line6`,
        `user_comment`
    )
    VALUES (
        transaction_reference,
        value_date,
        CURRENT_DATE(),
        transaction_type,
        NULL,
        amount_in_euro,
        '',
        '',
        '',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        user_comment
    );
END;;

DELIMITER ;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `cash_flow`;
CREATE TABLE `cash_flow` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `amount` double(8,2) NOT NULL,
  `descripton` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP VIEW IF EXISTS `get_all_transactions`;
CREATE TABLE `get_all_transactions` (`id` int(10), `transaction_reference` varchar(16), `value_date` date, `transaction_type` enum('C','D'), `amount_in_euro` double(17,2));


DROP TABLE IF EXISTS `invoice`;
CREATE TABLE `invoice` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `reference` varchar(8) NOT NULL,
  `member_ID` int(6) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `member_ID` (`member_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `ID` int(6) NOT NULL AUTO_INCREMENT,
  `membership_ID` int(2) NOT NULL,
  `IBAN` varchar(33) NOT NULL,
  `email` varchar(125) NOT NULL,
  `first_name` varchar(15) NOT NULL,
  `middle_name` varchar(15) NOT NULL,
  `last_name` varchar(35) NOT NULL,
  `adres` varchar(50) NOT NULL,
  `postalcode` varchar(6) NOT NULL,
  `city` varchar(25) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `email` (`email`),
  KEY `FK_membershipType` (`membership_ID`),
  CONSTRAINT `FK_membershipType` FOREIGN KEY (`membership_ID`) REFERENCES `membership_type` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `membership_payment`;
CREATE TABLE `membership_payment` (
  `transaction_ID` int(10) NOT NULL,
  `member_ID` int(6) NOT NULL,
  KEY `transaction_ID` (`transaction_ID`),
  KEY `member_ID` (`member_ID`),
  CONSTRAINT `FK_memberID` FOREIGN KEY (`member_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_transactionID` FOREIGN KEY (`transaction_ID`) REFERENCES `transaction` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `membership_type`;
CREATE TABLE `membership_type` (
  `ID` int(2) NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `price_per_month` double(4,2) NOT NULL,
  `payment_term` int(3) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `ID` int(1) NOT NULL AUTO_INCREMENT,
  `rolename` varchar(30) NOT NULL,
  `rolelevel` int(1) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `statements`;
CREATE TABLE `statements` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `transaction_reference` varchar(16) NOT NULL,
  `account` varchar(33) NOT NULL,
  `statement_number` varchar(5) NOT NULL,
  `sequence_number` varchar(5) NOT NULL,
  `transaction_type` enum('C','D') NOT NULL,
  `date` date NOT NULL,
  `currency` varchar(3) NOT NULL,
  `starting_balance` double(17,2) NOT NULL,
  `final_balance` double(17,2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `transaction_reference` (`transaction_reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `statements` (`ID`, `transaction_reference`, `account`, `statement_number`, `sequence_number`, `transaction_type`, `date`, `currency`, `starting_balance`, `final_balance`) VALUES
(1,	'P140220000000001',	'NL69INGB0123456789EUR',	'00000',	'null',	'C',	'2014-02-19',	'EUR',	662.23,	564.35),
(2,	'P140220000000001',	'NL69INGB0123456789EUR',	'00000',	'null',	'C',	'2014-02-19',	'EUR',	662.23,	564.35),
(3,	'P140220000000001',	'NL69INGB0123456789EUR',	'00000',	'null',	'C',	'2014-02-19',	'EUR',	662.23,	564.35),
(4,	'P140220000000001',	'NL69INGB0123456789EUR',	'00000',	'null',	'C',	'2014-02-19',	'EUR',	662.23,	564.35),
(5,	'test',	'',	'',	'',	'C',	'2023-07-02',	'',	2.50,	2.50),
(6,	'test',	'',	'',	'',	'C',	'2023-07-02',	'',	2.50,	2.50);

DROP TABLE IF EXISTS `transaction`;
CREATE TABLE `transaction` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `transaction_reference` varchar(16) NOT NULL,
  `value_date` date NOT NULL,
  `entry_date` date NOT NULL,
  `transaction_type` enum('C','D') NOT NULL,
  `fund_code` varchar(255) DEFAULT NULL,
  `amount_in_euro` double(17,2) NOT NULL,
  `identifier_code` varchar(4) NOT NULL,
  `owner_reference` varchar(35) NOT NULL,
  `beneficiary_reference` varchar(35) NOT NULL,
  `supplementary_details` varchar(34) DEFAULT NULL,
  `line1` varchar(65) DEFAULT NULL,
  `line2` varchar(65) DEFAULT NULL,
  `line3` varchar(65) DEFAULT NULL,
  `line4` varchar(65) DEFAULT NULL,
  `line5` varchar(65) DEFAULT NULL,
  `line6` varchar(65) DEFAULT NULL,
  `user_comment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `transaction_reference` (`transaction_reference`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`transaction_reference`) REFERENCES `statements` (`transaction_reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `ID` int(3) NOT NULL AUTO_INCREMENT,
  `role_ID` int(1) NOT NULL,
  `first_name` varchar(15) NOT NULL,
  `last_name` varchar(35) NOT NULL,
  `email` varchar(125) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `email` (`email`),
  KEY `role_ID` (`role_ID`),
  CONSTRAINT `FK_roleID` FOREIGN KEY (`role_ID`) REFERENCES `role` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `get_all_transactions`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_all_transactions` AS select `transaction`.`ID` AS `id`,`transaction`.`transaction_reference` AS `transaction_reference`,`transaction`.`value_date` AS `value_date`,`transaction`.`transaction_type` AS `transaction_type`,`transaction`.`amount_in_euro` AS `amount_in_euro` from `transaction`;

-- 2023-07-03 08:56:31
