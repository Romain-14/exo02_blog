-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 29, 2022 at 12:33 PM
-- Server version: 5.7.36
-- PHP Version: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blog`
--

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
CREATE TABLE IF NOT EXISTS `author` (
  `Id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`Id`, `FirstName`, `LastName`) VALUES
(1, 'Lovely', 'Love'),
(2, 'Twa', 'Mwa');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `Id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` varchar(40) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`Id`, `Name`) VALUES
(3, 'Lai Non Binèreuh'),
(2, 'Lé gars'),
(1, 'Lé koupines');

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
CREATE TABLE IF NOT EXISTS `comment` (
  `Id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NickName` varchar(30) DEFAULT NULL,
  `Contents` text NOT NULL,
  `CreationTimestamp` datetime NOT NULL,
  `Post_Id` smallint(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `CreationTimestamp` (`CreationTimestamp`),
  KEY `Post_Id` (`Post_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`Id`, `NickName`, `Contents`, `CreationTimestamp`, `Post_Id`) VALUES
(6, 'Ta besta', 'Oué ta trop rézon c abusé! vi1 on boi de la smirnoff ice et on fume des mentol pour se rebélé !', '2020-05-26 15:17:37', 6),
(7, 'Kévin', 'G un scoot si tu vE moi !', '2020-05-26 15:17:55', 6),
(12, 'Jessica ', 'c pk t tro cheum', '2020-05-28 11:41:01', 7),
(13, 'Lovely Star', 'Tu tcalm tt de suite Jessica, je c où tabit je v te prendr en 1V1 tu va pa comprendr', '2020-05-28 11:45:35', 7),
(15, 'Brian', 'jtle ldiiraiis a 16h park auchan su mSn\' biisOuS\r\n', '2020-05-28 11:50:28', 6),
(16, 'Jessica', 'Vazy rdv mercredi a la récré. T juste dead meuf', '2020-05-28 11:53:22', 7),
(17, 'Kevin', 'Tu la touch jte cass en 4 ok ?', '2020-05-28 11:54:50', 7),
(18, 'Brian', 'Oui en 8 mêm', '2020-05-28 11:56:52', 7),
(19, 'Moh', 'Kev et Briann vous deu jvou peta cbon ?', '2020-05-28 12:00:09', 7),
(20, 'Madame Dubois', 'Les enfants, vous recevrez bientôt une convocation chez le CPE.', '2020-05-28 12:08:00', 7),
(21, 'K-popLover', 'Hey HEy\r\n\r\nQui est fan de K-pop ? <3\r\n\r\n', '2020-05-28 12:54:11', 7),
(22, 'K-popLover', 'Jessica, Lovely Star, vené on fé une dance, genre Genie', '2020-05-28 12:54:46', 7),
(23, 'Ta besta', '<a href=\"https://google.com\"> coucou </a>', '2020-05-28 15:08:33', 7),
(24, 'test', 'test', '2020-10-16 15:05:48', 6),
(25, '', '', '2020-10-16 15:06:16', 6),
(26, 'luc', 'deterrage de topic je ferme', '2020-10-19 12:48:38', 7),
(27, 'Jean', 'WOUAHOU TRO FAUR', '2021-04-07 15:48:55', 6),
(28, 'bobo', 'Je suis un gros bobo parisien!', '2021-04-08 15:09:46', 6),
(29, 'anthony', 'Wai CYCKA BLYAT fraiRo', '2021-05-18 14:05:44', 6),
(30, 'RIBERY', 'la routourne à tourner', '2022-04-21 16:04:38', 7),
(31, 'zef', 'aze', '2022-04-25 12:32:31', 6),
(32, 'eza', 'aze', '2022-04-25 12:33:13', 6),
(33, 'aaaaaa', 'aaaaaaaaa', '2022-04-27 15:36:29', 7),
(34, 'aaaaaa', 'aaaaaaaaa', '2022-04-27 15:36:47', 7),
(35, 'hhhhhhhhhh', 'hhhhhhhhh', '2022-04-27 15:37:34', 7),
(36, 'kyukyukuik', 'loiluilulu', '2022-04-27 15:59:28', 7),
(37, 'njkghilkiul', 'limiomi', '2022-04-27 17:25:54', 7),
(38, 'gf', 'dg', '2022-04-27 20:46:17', 7);

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
CREATE TABLE IF NOT EXISTS `post` (
  `Id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Title` varchar(100) NOT NULL,
  `Contents` text NOT NULL,
  `CreationTimestamp` datetime NOT NULL,
  `Author_Id` tinyint(3) UNSIGNED DEFAULT NULL,
  `Category_Id` tinyint(3) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Title` (`Title`),
  KEY `CreationTimestamp` (`CreationTimestamp`),
  KEY `Author_Id` (`Author_Id`),
  KEY `Category_Id` (`Category_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `post`
--

INSERT INTO `post` (`Id`, `Title`, `Contents`, `CreationTimestamp`, `Author_Id`, `Category_Id`) VALUES
(6, 'ma mR me fé tro chiéz', 'Aujourd\'hui ma mR a pa voulu m\'acheté un scooter ! Franchement c tro abusé koi !!! En vré je sui tro une adulte mé elle m\'empeche d\'ê independante koi ! Je la deteste starfoula ! L é tro miskine koi ', '2020-05-26 15:16:52', 1, 1),
(7, 'La vi c toujour tro naz wesh', 'Kikou tou le monde !\r\nLa vi c tro de la merde Kév1 a choP 7 pouf de Jessica ! G tro le seum !!!!!!!! :( ', '2020-05-28 11:40:37', 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(120) NOT NULL,
  `Password` varchar(120) NOT NULL,
  `Role` varchar(10) NOT NULL,
  `FirstName` varchar(60) NOT NULL,
  `LastName` varchar(60) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`Id`, `Email`, `Password`, `Role`, `FirstName`, `LastName`) VALUES
(7, 'gege.riri@gmail.com', '$2b$10$ci5vI.FB2tPsH2hPVrmp5O8PXKqkHMkr1YwYYpRzdSA.EVXT6AyZG', 'admin', 'Gérard', 'Ricard'),
(8, 'jcvd@gmail.com', '$2b$10$xltuZJgD/gFfwNs2pXzy.es2YGCXmXEVTgR8W/cg3r1wiH.2CAGr2', 'user', 'Jean-Claude', 'Vandamme'),
(9, 'blabla@gmail.com', '$2b$10$vzEO5xQNSykwA8oLRygN2ujhiJ8zCvTfp8PqeUjTsPrXrmR.iFkWi', 'admin', 'antoine', 'monesma'),
(10, 'peter@parker.com', '$2b$10$jc/fMuciPXP.ExVoLm3GMeOukLHJKpMb5rEaAK3agMtHrUSl1qu9O', 'user', 'Peter', 'Parker'),
(11, 'admin@admin.com', '$2b$10$oDTWmQKjsdLdjOMq5LwnluhwuuBuzzbvtypvnRuy28CgO5eWO4DWW', 'admin', 'admin', 'admin'),
(13, 'zzz', '$2b$10$FWC4OOg/6XCzvl/0Xwu59uXe06OsCakhwMlKHQt.we3XsuJXw2zbW', 'user', 'zzz', 'zzz'),
(14, 'qq', '$2b$10$6LmZwM/DiDPg91eb4IkgzeRFLjo8xYvG.Ye4yxBx0LSEJDHd4zBGi', 'user', 'qq', 'qq'),
(15, 'gg', '$2b$10$MRtU0AFusDfjBIYnBXeKJeNaFcsIqPYKP8KJzUqmkCfWPtNOA2iPq', 'admin', 'gg', 'gg');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `Comment_ibfk_1` FOREIGN KEY (`Post_Id`) REFERENCES `post` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `Post_ibfk_1` FOREIGN KEY (`Author_Id`) REFERENCES `author` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `Post_ibfk_2` FOREIGN KEY (`Category_Id`) REFERENCES `category` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
