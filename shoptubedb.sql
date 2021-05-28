-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 09, 2021 at 08:27 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.4.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shoptubedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `firstName` varchar(125) NOT NULL,
  `lastName` varchar(125) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` varchar(25) NOT NULL,
  `address` text NOT NULL,
  `password` varchar(100) NOT NULL,
  `type` varchar(20) NOT NULL,
  `confirmCode` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `firstName`, `lastName`, `email`, `mobile`, `address`, `password`, `type`, `confirmCode`) VALUES
(4, 'Nur', 'Mohsin', 'mohsin@gmail.com', '01677876551', 'Dhaka', '$5$rounds=535000$WOAOMdgoK2JpZLY5$RFH9BZQCB3NEvG4R/FofxxJL/PUaeZm7T6G9P3PRg05', 'manager', '0'),
(5, 'ffsfs', 'sfsfs', 'fsfsfffs@gmail.com', '1244664681', 'dwqawdasdasdsad', 'dasdsdsads', 'md', ''),
(6, 'Harish', 'P', 'haaaa@gmail.com', '9987774563', '', '$5$rounds=535000$Gcy8hVj2rUyWhP0v$NEVcvKxkjIoJYkv2OqVD8A323WbrQxH587Qz/ZFGLv7', 'MD', '');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `sid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`sid`, `uid`, `pid`, `quantity`) VALUES
(11, 16, 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `ofname` text NOT NULL,
  `pid` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `oplace` text NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `dstatus` varchar(10) NOT NULL DEFAULT 'no',
  `odate` timestamp NOT NULL DEFAULT current_timestamp(),
  `ddate` date DEFAULT NULL,
  `pname` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `uid`, `ofname`, `pid`, `quantity`, `oplace`, `mobile`, `dstatus`, `odate`, `ddate`, `pname`, `status`) VALUES
(1, NULL, 'Kashmiri Chador', 1, 2, 'Khilkhet, Dhaka', '01609876543', 'no', '2018-09-21 13:05:07', NULL, '', ''),
(2, NULL, 'Nur Mohsin', 1, 3, 'Khilkhet, Dhaka', '01609876543', 'no', '2018-09-21 13:08:55', NULL, '', ''),
(3, NULL, 'Nur Mohsin', 2, 4, 'Dhaka', '09876543123', 'no', '2018-09-21 13:13:04', NULL, '', ''),
(4, NULL, 'Nur Mohsin', 4, 1, 'Manikganj', '798345', 'no', '2018-09-21 13:18:47', NULL, '', ''),
(5, NULL, 'Nur Mohsin', 9, 4, 'Dhaka, Bangladesh', '01609876543', 'no', '2018-09-22 02:01:02', NULL, '', ''),
(6, NULL, 'Nur Mohsin', 2, 1, 'Manikganj', '01609876543', 'no', '2018-09-22 02:09:29', NULL, '', ''),
(7, 9, 'Nur Mohsin', 2, 1, 'Manikganj', '01609876543', 'no', '2018-09-22 02:10:46', NULL, '', ''),
(8, 9, 'Nur Mohsin', 1, 1, 'Manikganj', '0994', 'no', '2018-09-22 03:04:13', NULL, '', ''),
(9, 9, 'Kashmiri Chador', 12, 4, 'Dhaka', '01609876543', 'no', '2018-09-22 03:21:14', '2018-09-29', '', ''),
(10, 9, 'Chador', 13, 1, 'Dhaka', '01609876543', 'no', '2018-09-22 03:22:05', '2018-09-29', '', ''),
(11, NULL, 'harish', 0, 0, 'radio mirchi', '121365478987', 'no', '2021-03-27 15:15:45', NULL, '', ''),
(12, 16, '', 10, 1, '', '', 'no', '2021-03-27 15:29:35', '2021-04-03', '', ''),
(13, 16, '', 10, 1, '', '', 'no', '2021-03-27 15:57:56', '2021-04-03', '', ''),
(14, 16, '', 5, 1, '', '', 'no', '2021-03-29 15:07:41', '2021-04-05', '', ''),
(15, 16, '', 9, 1, '', '', 'no', '2021-03-30 13:56:14', '2021-04-06', '', ''),
(16, 16, 'harish', 1, 1, '', '121365478987', 'no', '2021-03-30 15:11:21', '2021-04-06', '', ''),
(18, 17, 'beep', 1, 3, 'chennai silks', '12365478974', 'no', '2021-04-05 03:48:57', '2021-04-12', '', ''),
(22, 17, 'beep', 12, 1, 'chennai silks', '12365478974', 'no', '2021-04-05 06:02:42', '2021-04-12', 'T-Shirt', ''),
(23, 17, 'beep', 9, 1, 'chennai silks', '12365478974', 'no', '2021-04-24 07:46:39', '2021-05-01', 'T-Shirt', ''),
(24, 17, 'beep', 8, 1, 'chennai silks', '12365478974', 'no', '2021-04-24 07:47:49', '2021-05-01', 'T-Shirt', ''),
(25, 17, 'beep', 8, 1, 'chennai silks', '12365478974', 'no', '2021-04-24 07:48:37', '2021-05-01', 'T-Shirt', ''),
(26, 17, 'beep', 17, 1, 'chennai silks', '12365478974', 'no', '2021-04-24 10:53:46', '2021-05-01', 'Leather Wallet', ''),
(27, 17, 'beep', 6, 1, 'chennai silks', '12365478974', 'no', '2021-04-24 11:00:44', '2021-05-01', 'T-shirt', ''),
(28, 17, 'harish', 28, 5, 'chennai silks', '12365478974', 'no', '2021-05-09 14:33:24', '2021-05-16', 'Country Egg', ''),
(29, 17, 'harish', 40, 9, 'chennai silks', '12365478974', 'no', '2021-05-09 17:12:06', '2021-05-16', 'Mutton', '');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `pName` varchar(100) NOT NULL,
  `price` int(11) NOT NULL,
  `description` text NOT NULL,
  `available` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `item` varchar(100) NOT NULL,
  `pCode` varchar(20) NOT NULL,
  `picture` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `pName`, `price`, `description`, `available`, `category`, `item`, `pCode`, `picture`, `date`) VALUES
(27, 'Egg', 5, 'White Egg', 100, 'eggmeatfish', 'Egg', 'M001', 'egg.jpg', '2021-05-09 14:29:07'),
(28, 'Country Egg', 15, 'Country Egg ', 100, 'eggmeatfish', 'Country Egg', 'M002', 'country_egg.jpg', '2021-05-09 14:30:16'),
(29, 'Chicken ', 150, 'Chicken 1KG', 100, 'eggmeatfish', 'Chicken', 'M003', 'chicken.jpg', '2021-05-09 14:31:19'),
(31, 'Prawn', 200, 'Prawn 1kg', 100, 'eggmeatfish', 'Prawn', 'M005', 'prawn.jpg', '2021-05-09 15:27:44'),
(32, 'Mutton Leg', 350, 'Fresh Mutton leg fully cleaned', 100, 'eggmeatfish', 'Mutton Leg', 'M006', 'mutton.jpg', '2021-05-09 15:28:33'),
(33, 'Squid', 600, 'Squid 1KG fresh ', 100, 'eggmeatfish', 'Squid', 'M007', 'Squid.jpg', '2021-05-09 15:29:27'),
(35, 'Fish', 150, 'Fish 1 kg fresh ', 100, 'eggmeatfish', 'Fish', 'M009', 'fish.jpg', '2021-05-09 15:31:16'),
(38, 'Seer Fish', 900, 'Seer fish Vanjaram 1 KG', 100, 'eggmeatfish', 'seer', 'M008', 'seer_full_slice.jpg', '2021-05-09 15:42:13'),
(40, 'Mutton', 400, 'Mutton 1Kg ', 100, 'eggmeatfish', 'mutton', 'M004', 'mutton1.jpg', '2021-05-09 15:53:21'),
(41, 'Vim Bar', 15, 'Vim bar for dish washing', 100, 'homecare', 'Vim', 'H001', '61szrCRWOEL._AC_SY355_.jpg', '2021-05-09 17:15:24'),
(42, 'Scotch Brite', 15, 'Scotch brite scruber for dish washing', 100, 'homecare', 'Scotch brite', 'H002', '81-TCD5hJ3L._AC_SX466_.jpg', '2021-05-09 17:16:18'),
(43, 'Ariel', 150, 'Ariel Washing powder ', 100, 'homecare', 'ariel', 'H003', '111-500x500.jpg', '2021-05-09 17:17:07'),
(44, 'Surf Excel', 180, 'Surf Excel washing powder', 100, 'homecare', 'surfexcel', 'H004', '16118_h-8901030711565.jpg', '2021-05-09 17:18:05'),
(45, 'Comfort', 130, 'Comfort Fabric Conditioner', 100, 'homecare', 'comforte', 'H005', '230745_18-comfort-after-wash-morning-fresh-fabric-conditioner.jpg', '2021-05-09 17:18:58'),
(46, 'Harpic-B', 200, 'Harpic Bathroom cleaner', 100, 'homecare', 'harpic-b', 'H006', '40017766_10-harpic-disinfectant-bathroom-cleaner-liquid-floral.jpg', '2021-05-09 17:19:57'),
(47, 'Harpic', 180, 'Harpic toilet Cleaner', 100, 'homecare', 'harpic', 'H007', 'harpic.jpg', '2021-05-09 17:20:41'),
(48, 'Lizol', 160, 'Lizol Floor Cleaner', 100, 'homecare', 'lizol', 'H008', 'lizol-floor-cleaner-500x500.jpg', '2021-05-09 17:21:18'),
(49, 'Rin-soap', 70, 'Rin Washing soap', 100, 'homecare', 'rinsoap', 'H009', 'rin-500x500.jpg', '2021-05-09 17:22:12'),
(50, 'Rin-powder', 100, 'Rin washing Powder', 100, 'homecare', 'rinpowder', 'H010', 'rin-washing-powder-power-bright-1kg.jpg', '2021-05-09 17:22:55'),
(51, 'Detol-soap', 50, 'Detol Bathing soap 18g', 100, 'homecare', 'detolsoap', 'H011', 'dettol-bath-soap-500x500.jpg', '2021-05-09 17:33:57'),
(52, 'Fiama', 250, 'Fiama Bathing Soap 5 set', 100, 'homecare', 'fiama', 'H0012', 'fiama.jpg', '2021-05-09 17:37:50'),
(53, 'Dettol-a', 150, 'Dettol Antiseptic', 100, 'homecare', 'detol-a', 'H013', 'RECK_9300631016076-0-1200x1200.jpg', '2021-05-09 17:38:57'),
(54, 'Dettol-H', 90, 'Dettol Handwash', 100, 'homecare', 'dettolh', 'H014', 'ULB8C6GpsrnJXKJkSahGq6xhzFXaB.jpg', '2021-05-09 17:39:50'),
(55, 'Good Night', 120, 'Good night mousquito repealent', 100, 'homecare', 'goodnight', 'H015', 'Godrej-Goodknight-Power-Activ-System-Mosquito-Repellent-Combo-Pack-Machine-Refill-45-ml.jpg', '2021-05-09 17:43:00'),
(56, 'Odonil', 160, 'Odonil bathroom Freashner', 100, 'homecare', 'odonil', 'H016', 'b00kimhr0q_odonil_blocks_50gm_mix_3_1_78314935_1.jpg', '2021-05-09 17:44:10'),
(57, 'Apple', 80, 'Apple1 KG', 100, 'fruitsandvegitables', 'apple`', 'F001', 'ordinary-fruits-with-amazing-health-benefits-03-1440x810.jpg', '2021-05-09 18:08:33'),
(58, 'Pomogranet', 100, 'pomogranet 1 KG', 100, 'fruitsandvegitables', 'pomogranet', 'H002', '_power_fruit_pomegranate_0.jpg', '2021-05-09 18:09:21'),
(59, 'Banana', 40, 'banana 1 Dosen', 100, 'fruitsandvegitables', 'banana', 'H003', 'Bananas-5c6a36a346e0fb0001f0e4a3.jpg', '2021-05-09 18:10:26'),
(60, 'Strawberry', 200, 'Strawberry 1 box', 100, 'fruitsandvegitables', 'strawberry', 'H004', 'strawberries.jpg', '2021-05-09 18:18:48'),
(61, 'DragonFruit', 200, 'Dragon Fruit 1 kg', 100, 'fruitsandvegitables', 'dragonfruit', 'H005', 'Pitaya_cross_section_ed2.jpg', '2021-05-09 18:19:27'),
(62, 'horlics', 180, 'Horlics energy powder', 100, 'bevearages', 'horlics', 'B001', '51ye7gOYXcL._SL1100_.jpg', '2021-05-09 18:23:55'),
(63, 'Tea', 30, 'Tea powder ', 100, 'bevearages', 'tea', 'B001', 'tea-powder-500x500.jpg', '2021-05-09 18:24:34'),
(64, 'Bournvita', 200, 'Bournvita Drink Powder 500g', 100, 'bevearages', 'bournvita', 'B001', '102833_15-cadbury-chocolate-health-drink-bournvita-refill-pack.jpg', '2021-05-09 18:26:01');

-- --------------------------------------------------------

--
-- Table structure for table `product_level`
--

CREATE TABLE `product_level` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `v_shape` varchar(10) NOT NULL DEFAULT 'no',
  `polo` varchar(10) NOT NULL DEFAULT 'no',
  `clean_text` varchar(10) NOT NULL DEFAULT 'no',
  `design` varchar(10) NOT NULL DEFAULT 'no',
  `chain` varchar(10) NOT NULL DEFAULT 'no',
  `leather` varchar(10) NOT NULL DEFAULT 'no',
  `hook` varchar(10) NOT NULL DEFAULT 'no',
  `color` varchar(10) NOT NULL DEFAULT 'no',
  `formal` varchar(10) NOT NULL DEFAULT 'no',
  `converse` varchar(10) NOT NULL DEFAULT 'no',
  `loafer` varchar(10) NOT NULL DEFAULT 'no'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_level`
--

INSERT INTO `product_level` (`id`, `product_id`, `v_shape`, `polo`, `clean_text`, `design`, `chain`, `leather`, `hook`, `color`, `formal`, `converse`, `loafer`) VALUES
(1, 1, 'no', 'no', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(2, 2, 'no', 'no', 'no', 'no', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no'),
(3, 3, 'no', 'no', 'no', 'no', 'no', 'yes', 'no', 'no', 'no', 'no', 'yes'),
(4, 4, 'no', 'no', 'no', 'no', 'no', 'yes', 'yes', 'no', 'no', 'no', 'no'),
(5, 5, 'no', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(6, 6, 'no', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(7, 7, 'yes', 'no', 'no', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(8, 8, 'no', 'no', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(9, 9, 'yes', 'no', 'no', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(10, 10, 'yes', 'no', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(14, 14, 'no', 'no', 'no', 'no', 'no', 'yes', 'yes', 'no', 'no', 'no', 'no'),
(12, 12, 'yes', 'no', 'no', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(13, 13, 'no', 'no', 'no', 'no', 'no', 'yes', 'no', 'no', 'no', 'no', 'yes'),
(15, 15, 'no', 'no', 'no', 'no', 'no', 'yes', 'no', 'yes', 'no', 'no', 'no'),
(16, 16, 'no', 'no', 'no', 'no', 'no', 'yes', 'yes', 'yes', 'no', 'no', 'no'),
(17, 17, 'no', 'no', 'no', 'no', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no'),
(18, 18, 'no', 'no', 'no', 'no', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no'),
(19, 19, 'no', 'no', 'no', 'yes', 'yes', 'yes', 'no', 'no', 'no', 'no', 'no'),
(20, 20, 'no', 'no', 'no', 'no', 'no', 'yes', 'no', 'no', 'no', 'yes', 'no'),
(21, 21, 'no', 'no', 'no', 'no', 'no', 'yes', 'no', 'no', 'yes', 'no', 'no'),
(22, 22, 'no', 'yes', 'no', 'yes', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(23, 27, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(24, 28, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(25, 29, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(26, 30, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(27, 31, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(28, 32, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(29, 33, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(30, 34, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(31, 35, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(32, 36, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(33, 37, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(34, 38, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(35, 39, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(36, 40, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(37, 41, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(38, 42, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(39, 43, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(40, 44, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(41, 45, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(42, 46, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(43, 47, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(44, 48, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(45, 49, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(46, 50, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(47, 51, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(48, 52, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(49, 53, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(50, 54, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(51, 55, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(52, 56, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(53, 57, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(54, 58, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(55, 59, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(56, 60, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(57, 61, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(58, 62, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(59, 63, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(60, 64, 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `product_view`
--

CREATE TABLE `product_view` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_view`
--

INSERT INTO `product_view` (`id`, `user_id`, `product_id`, `date`) VALUES
(1, 9, 9, '2018-09-22 02:19:30'),
(2, 9, 7, '2018-09-27 02:47:43'),
(3, 9, 12, '2018-09-22 03:20:59'),
(4, 9, 10, '2018-09-29 03:07:11'),
(5, 9, 5, '2018-09-22 03:19:19'),
(6, 9, 8, '2018-09-21 15:57:50'),
(7, 9, 6, '2018-09-22 02:12:54'),
(8, 9, 1, '2018-09-22 03:03:36'),
(9, 16, 10, '2021-03-30 15:03:54'),
(10, 16, 7, '2021-03-30 15:10:24'),
(11, 16, 8, '2021-03-30 15:10:47'),
(12, 16, 5, '2021-03-29 15:07:40'),
(13, 16, 12, '2021-03-30 15:02:10'),
(14, 16, 6, '2021-03-29 14:58:59'),
(15, 16, 9, '2021-03-30 15:03:05'),
(16, 16, 1, '2021-03-30 15:11:20'),
(17, 17, 7, '2021-04-24 07:44:32'),
(18, 17, 5, '2021-04-24 07:39:13'),
(19, 17, 8, '2021-04-24 07:48:09'),
(20, 17, 1, '2021-04-24 10:51:22'),
(21, 17, 9, '2021-04-24 07:46:09'),
(22, 17, 12, '2021-04-24 07:27:08'),
(23, 17, 6, '2021-04-24 11:00:06'),
(24, 17, 10, '2021-04-24 07:57:35');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `username` varchar(25) NOT NULL,
  `password` varchar(100) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `reg_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `online` varchar(1) NOT NULL DEFAULT '0',
  `activation` varchar(3) NOT NULL DEFAULT 'yes',
  `oplace` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `username`, `password`, `mobile`, `reg_time`, `online`, `activation`, `oplace`) VALUES
(12, 'Mukul', 'mukul@gmail.com', 'mukul', '$5$rounds=535000$6PJhbzFlfJbcQbza$FbrPa3qqk1RJ5MSffRLO6LrQJXbgO8SudFuBpNf.wR7', '', '2018-07-23 14:09:14', '0', 'yes', ''),
(9, 'Nur Mohsin', 'mohsin@gmail.com', 'mohsin', '$5$rounds=535000$EnLkwqfGWGcWklRL$q9PbYw/TVXSzs.QpgUouZ3.6BzaPG2eLHkTyv.Qx80D', '123456789022', '2018-07-21 06:47:57', '1', 'yes', ''),
(14, 'Nur Mohsin', 'khan@gmail.com', 'khan', '$5$rounds=535000$wLKTQexvPQHueUsK$aFrFUXBHjrrAH61EFiYgj8cZECaaz8y6S5XS/zkkHw9', '', '2018-09-07 09:02:35', '0', 'yes', ''),
(13, 'Robin', 'robin@gmail.com', 'robin', '$5$rounds=535000$uiZc/VCwwa3XCTTe$Ec.JOjy4GkjpAXHtAvGt6pSc6KszajHgcyZy8v6Ivk1', '', '2018-07-26 12:36:57', '0', 'yes', ''),
(15, 'Sujon', 'sujon@yahoo.com', 'sujons', '$5$rounds=535000$aGykDT1yrocgTaDt$p2dDAMDz9g3N6o/Jj7QJY9B6NnMlUot.DCq/LOsCS13', '89345793753', '2018-09-08 13:58:36', '0', 'yes', ''),
(16, 'harish', 'harishpp@gmail.com', 'hppp', '$5$rounds=535000$8nSaCwm0KmUjomp0$kgLm4KwESbmFsTzQWUTyYQRXbubcrR/rDcuJloWuhG1', '121365478987', '2021-03-27 15:15:45', '0', 'yes', ''),
(17, 'harish', 'harish123@gmail.com', 'hppp1', '$5$rounds=535000$Po3egsratsJcogcH$kMNutz8J4u18JiZhV3I1C4MSy4l5p4jT4BYctDDRNO0', '12365478974', '2021-03-30 15:12:07', '1', 'yes', 'chennai silks');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`sid`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_level`
--
ALTER TABLE `product_level`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_view`
--
ALTER TABLE `product_view`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `sid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `product_level`
--
ALTER TABLE `product_level`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `product_view`
--
ALTER TABLE `product_view`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
