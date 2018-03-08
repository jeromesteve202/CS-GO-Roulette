SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `csgo`
--

-- --------------------------------------------------------

--
-- Table structure for table `bets`
--

CREATE TABLE IF NOT EXISTS `bets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(17) NOT NULL,
  `collect` int(11) NOT NULL DEFAULT '0',
  `amount` int(11) NOT NULL,
  `lower` int(11) NOT NULL,
  `upper` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bots`
--

CREATE TABLE IF NOT EXISTS `bots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `online` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `shared_secret` varchar(28) NOT NULL,
  `identity_secret` varchar(28) NOT NULL,
  `accountName` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `steamguard` varchar(64) NOT NULL,
  `email_login` varchar(64) NOT NULL,
  `email_password` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `codes`
--

CREATE TABLE IF NOT EXISTS `codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(16) NOT NULL,
  `user` varchar(17) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `hash`
--

CREATE TABLE IF NOT EXISTS `hash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` bigint(20) NOT NULL,
  `hash` varchar(256) NOT NULL,
  `no_hash` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trade` bigint(20) NOT NULL,
  `market_hash_name` varchar(512) NOT NULL,
  `status` int(11) NOT NULL,
  `img` text NOT NULL,
  `botid` int(11) NOT NULL,
  `time` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf32 AUTO_INCREMENT=122 ;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket` int(11) NOT NULL,
  `message` text NOT NULL,
  `user` varchar(17) NOT NULL,
  `time` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `rolls`
--

CREATE TABLE IF NOT EXISTS `rolls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roll` int(11) NOT NULL,
  `hash` varchar(256) NOT NULL,
  `time` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL DEFAULT '0',
  `time` bigint(20) NOT NULL,
  `user` varchar(17) NOT NULL,
  `cat` int(11) NOT NULL,
  `title` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `trades`
--

CREATE TABLE IF NOT EXISTS `trades` (
  `id` bigint(11) NOT NULL,
  `bot_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `user` varchar(17) NOT NULL,
  `summa` int(16) NOT NULL,
  `code` varchar(16) NOT NULL,
  `time` bigint(20) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `transfers`
--

CREATE TABLE IF NOT EXISTS `transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from1` varchar(17) NOT NULL,
  `to1` varchar(17) NOT NULL,
  `amount` int(11) NOT NULL,
  `note` varchar(32) NOT NULL,
  `time` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steamid` varchar(17) NOT NULL,
  `mute` bigint(11) NOT NULL,
  `name` varchar(512) NOT NULL,
  `referral` varchar(17) NOT NULL DEFAULT '0',
  `rank` varchar(16) DEFAULT '0',
  `balance` int(11) NOT NULL,
  `avatar` text NOT NULL,
  `hash` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
