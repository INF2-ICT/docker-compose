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

INSERT INTO `role` (`ID`, `rolename`, `rolelevel`) VALUES
(1,	'user',	1),
(2,	'penningmeester',	2);

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
(3,	'P140220000000001',	'NL69INGB0123456789EUR',	'00000',	'null',	'C',	'2014-02-19',	'EUR',	662.23,	564.35);

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

INSERT INTO `transaction` (`ID`, `transaction_reference`, `value_date`, `entry_date`, `transaction_type`, `fund_code`, `amount_in_euro`, `identifier_code`, `owner_reference`, `beneficiary_reference`, `supplementary_details`, `line1`, `line2`, `line3`, `line4`, `line5`, `line6`, `user_comment`) VALUES
(1,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.56,	'TRF',	'EREF',	'00000000001005',	'/TRCD/00100/',	'/EREF/EV12341REP1231456T1234//CNTP/NL32INGB0000012345/INGBNL2',	'A/ING BANK NV INZAKE WEB///REMI/USTD//EV10001REP1000000T1000/',	'null',	'null',	'null',	'null',	NULL),
(2,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	1.57,	'TRF',	'PREF',	'00000000001006',	'/TRCD/00200/',	'/PREF/M000000003333333//REMI/USTD//TOTAAL 1 VZ/',	'null',	'null',	'null',	'null',	'null',	NULL),
(3,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.57,	'RTI',	'EREF',	'00000000001007',	'/TRCD/00190/',	'/RTRN/MS03//EREF/20120123456789//CNTP/NL32INGB0000012345/INGB',	'NL2A/J.Janssen///REMI/USTD//Factuurnr 123456 Klantnr 00123/',	'null',	'null',	'null',	'null',	NULL),
(4,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	1.14,	'DDT',	'EREF',	'00000000001009',	'/TRCD/01016/',	'/EREF/EV123REP123412T1234//MARF/MND-EV01//CSID/NL32ZZZ9999999',	'91234//CNTP/NL32INGB0000012345/INGBNL2A/ING Bank N.V. inzake WeB/',	'//REMI/USTD//EV123REP123412T1234/',	'null',	'null',	'null',	NULL),
(5,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.45,	'DDT',	'PREF',	'00000000001008',	'/TRCD/01000/',	'/PREF/M000000001111111//CSID/NL32ZZZ999999991234//REMI/USTD//',	'TOTAAL       1 POSTEN/',	'null',	'null',	'null',	'null',	NULL),
(6,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	12.75,	'RTI',	'EREF',	'00000000001010',	'/TRCD/01315/',	'/RTRN/MS03//EREF/20120501P0123478//MARF/MND-120123//CSID/NL32',	'ZZZ999999991234//CNTP/NL32INGB0000012345/INGBNL2A/J.Janssen///REM',	'I/USTD//CONTRIBUTIE FEB 2014/',	'null',	'null',	'null',	NULL),
(7,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	32.00,	'TRF',	'9001123412341234',	'00000000001011',	'/TRCD/00108/',	'/EREF/15814016000676480//CNTP/NL32INGB0000012345/INGBNL2A/J.J',	'anssen///REMI/STRD/CUR/9001123412341234/',	'null',	'null',	'null',	'null',	NULL),
(8,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	119.00,	'TRF',	'1070123412341234',	'00000000001012',	'/TRCD/00108/',	'/EREF/15614016000384600//CNTP/NL32INGB0000012345/INGBNL2A/ING',	'BANK NV///REMI/STRD/CUR/1070123412341234/',	'null',	'null',	'null',	'null',	NULL),
(9,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.56,	'TRF',	'EREF',	'00000000001005',	'/TRCD/00100/',	'/EREF/EV12341REP1231456T1234//CNTP/NL32INGB0000012345/INGBNL2',	'A/ING BANK NV INZAKE WEB///REMI/USTD//EV10001REP1000000T1000/',	'null',	'null',	'null',	'null',	NULL),
(10,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	1.57,	'TRF',	'PREF',	'00000000001006',	'/TRCD/00200/',	'/PREF/M000000003333333//REMI/USTD//TOTAAL 1 VZ/',	'null',	'null',	'null',	'null',	'null',	NULL),
(11,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.57,	'RTI',	'EREF',	'00000000001007',	'/TRCD/00190/',	'/RTRN/MS03//EREF/20120123456789//CNTP/NL32INGB0000012345/INGB',	'NL2A/J.Janssen///REMI/USTD//Factuurnr 123456 Klantnr 00123/',	'null',	'null',	'null',	'null',	NULL),
(12,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	1.14,	'DDT',	'EREF',	'00000000001009',	'/TRCD/01016/',	'/EREF/EV123REP123412T1234//MARF/MND-EV01//CSID/NL32ZZZ9999999',	'91234//CNTP/NL32INGB0000012345/INGBNL2A/ING Bank N.V. inzake WeB/',	'//REMI/USTD//EV123REP123412T1234/',	'null',	'null',	'null',	NULL),
(13,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.45,	'DDT',	'PREF',	'00000000001008',	'/TRCD/01000/',	'/PREF/M000000001111111//CSID/NL32ZZZ999999991234//REMI/USTD//',	'TOTAAL       1 POSTEN/',	'null',	'null',	'null',	'null',	NULL),
(14,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	12.75,	'RTI',	'EREF',	'00000000001010',	'/TRCD/01315/',	'/RTRN/MS03//EREF/20120501P0123478//MARF/MND-120123//CSID/NL32',	'ZZZ999999991234//CNTP/NL32INGB0000012345/INGBNL2A/J.Janssen///REM',	'I/USTD//CONTRIBUTIE FEB 2014/',	'null',	'null',	'null',	NULL),
(15,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	32.00,	'TRF',	'9001123412341234',	'00000000001011',	'/TRCD/00108/',	'/EREF/15814016000676480//CNTP/NL32INGB0000012345/INGBNL2A/J.J',	'anssen///REMI/STRD/CUR/9001123412341234/',	'null',	'null',	'null',	'null',	NULL),
(16,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	119.00,	'TRF',	'1070123412341234',	'00000000001012',	'/TRCD/00108/',	'/EREF/15614016000384600//CNTP/NL32INGB0000012345/INGBNL2A/ING',	'BANK NV///REMI/STRD/CUR/1070123412341234/',	'null',	'null',	'null',	'null',	NULL),
(17,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.56,	'TRF',	'EREF',	'00000000001005',	'/TRCD/00100/',	'/EREF/EV12341REP1231456T1234//CNTP/NL32INGB0000012345/INGBNL2',	'A/ING BANK NV INZAKE WEB///REMI/USTD//EV10001REP1000000T1000/',	'null',	'null',	'null',	'null',	NULL),
(18,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	1.57,	'TRF',	'PREF',	'00000000001006',	'/TRCD/00200/',	'/PREF/M000000003333333//REMI/USTD//TOTAAL 1 VZ/',	'null',	'null',	'null',	'null',	'null',	NULL),
(19,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.57,	'RTI',	'EREF',	'00000000001007',	'/TRCD/00190/',	'/RTRN/MS03//EREF/20120123456789//CNTP/NL32INGB0000012345/INGB',	'NL2A/J.Janssen///REMI/USTD//Factuurnr 123456 Klantnr 00123/',	'null',	'null',	'null',	'null',	NULL),
(20,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	1.14,	'DDT',	'EREF',	'00000000001009',	'/TRCD/01016/',	'/EREF/EV123REP123412T1234//MARF/MND-EV01//CSID/NL32ZZZ9999999',	'91234//CNTP/NL32INGB0000012345/INGBNL2A/ING Bank N.V. inzake WeB/',	'//REMI/USTD//EV123REP123412T1234/',	'null',	'null',	'null',	NULL),
(21,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	1.45,	'DDT',	'PREF',	'00000000001008',	'/TRCD/01000/',	'/PREF/M000000001111111//CSID/NL32ZZZ999999991234//REMI/USTD//',	'TOTAAL       1 POSTEN/',	'null',	'null',	'null',	'null',	NULL),
(22,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	12.75,	'RTI',	'EREF',	'00000000001010',	'/TRCD/01315/',	'/RTRN/MS03//EREF/20120501P0123478//MARF/MND-120123//CSID/NL32',	'ZZZ999999991234//CNTP/NL32INGB0000012345/INGBNL2A/J.Janssen///REM',	'I/USTD//CONTRIBUTIE FEB 2014/',	'null',	'null',	'null',	NULL),
(23,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'C',	'null',	32.00,	'TRF',	'9001123412341234',	'00000000001011',	'/TRCD/00108/',	'/EREF/15814016000676480//CNTP/NL32INGB0000012345/INGBNL2A/J.J',	'anssen///REMI/STRD/CUR/9001123412341234/',	'null',	'null',	'null',	'null',	NULL),
(24,	'P140220000000001',	'2014-02-20',	'2014-02-20',	'D',	'null',	119.00,	'TRF',	'1070123412341234',	'00000000001012',	'/TRCD/00108/',	'/EREF/15614016000384600//CNTP/NL32INGB0000012345/INGBNL2A/ING',	'BANK NV///REMI/STRD/CUR/1070123412341234/',	'null',	'null',	'null',	'null',	NULL);

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

INSERT INTO `user` (`ID`, `role_ID`, `first_name`, `last_name`, `email`, `password`) VALUES
(1,	2,	'Pascal',	'Snippen',	'psnippen@quintor.nl',	'$2y$10$95VzIaPeUbo2vZdKHz5WP.8jKRujKG/jXhgN7FcKYyLnMekdljwAu'),
(2,	1,	'Stefan',	'Meijer',	'stefan.meijer3@student.nhlstenden.com',	'$2y$10$vg0y9Nu31YfHckpDVproxOFSnyU1AxwrcVflhOb9nzhBoWoIdLmMi'),
(3,	1,	'Hajo',	'Hilbrands',	'hajo.hilbrands@student.nhlstenden.com',	'$2y$10$.fxNF46OodTd2YXcRoL78.qpIcN27eSYCc1VzQZD1kYOmFFpHYKJ6'),
(4,	1,	'Nick',	'Buisman',	'nick.buisman@student.nhlstenden.com',	'$2y$10$dO9P2TDNhLHCgc3DmG1VD.KDnuD0NO3pM8pGfDGlMYZeNGhWIIxQS'),
(5,	1,	'Robin',	'Van Dijk',	'robin.van.dijk1@student.nhlstenden.com',	'$2y$10$KHn/N2.SWoQ02UKGsRYg5uRpw4HcMZJ4yjjwmonAYUIsY2ycw6k4S');

DROP TABLE IF EXISTS `get_all_transactions`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_all_transactions` AS select `transaction`.`ID` AS `id`,`transaction`.`transaction_reference` AS `transaction_reference`,`transaction`.`value_date` AS `value_date`,`transaction`.`transaction_type` AS `transaction_type`,`transaction`.`amount_in_euro` AS `amount_in_euro` from `transaction`;

-- 2023-06-28 14:47:31
