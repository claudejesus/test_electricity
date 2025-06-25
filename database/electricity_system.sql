-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2025 at 09:53 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `electricity_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `cashpower`
--

CREATE TABLE `cashpower` (
  `id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `balance` double NOT NULL DEFAULT 0,
  `unit` decimal(10,2) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cashpower`
--

INSERT INTO `cashpower` (`id`, `amount`, `balance`, `unit`, `price`, `created_at`) VALUES
(7, '1000.00', 0, '2.00', '500.00', '2025-06-24 23:03:31'),
(8, '3000.00', 0, '6.00', '500.00', '2025-06-24 23:06:06'),
(9, '5000.00', 10, '10.00', '500.00', '2025-06-24 23:07:51'),
(10, '1500.00', 500, '1.50', '1000.00', '2025-06-24 23:08:51'),
(15, '1234.00', 1234, '23.00', '53.65', '2025-06-25 16:09:18'),
(16, '23456.00', 23456, '87654321.00', '0.00', '2025-06-25 17:13:27'),
(17, '220.00', 200, '23.00', '9.57', '2025-06-25 18:38:51'),
(18, '23.00', 0, '43.00', '0.53', '2025-06-25 18:39:05'),
(19, '1000.00', 1000, '6.00', '166.67', '2025-06-25 19:43:06');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `landlords`
--

CREATE TABLE `landlords` (
  `id` int(100) NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(25) NOT NULL,
  `address` text NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `landlords`
--

INSERT INTO `landlords` (`id`, `name`, `phone`, `address`, `password`) VALUES
(11, 'berthe', '0799590910', 'nyaruguru', '$2y$10$swJQljDvBYBDIVgImxSkjeeoZWSVumfrlLPR/m3bHE2r1.jRwZQIe');

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `house_number` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `landlord_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`id`, `name`, `phone`, `house_number`, `password`, `landlord_id`) VALUES
(22, 'sarah', '0735558102', '3', '$2y$10$vFg3j7ZdARXxOXU1zm53OefZv4fEEfP4bBMeZ98fnWmncoWbiyKmO', 11),
(24, 'aline', '0785558102', '5', '$2y$10$juHk9XtRkg/XbkMB1TEDPe4zgCasfNrHgaXIZSj/KVtiDwWnazGra', 11);

-- --------------------------------------------------------

--
-- Table structure for table `tenant_power`
--

CREATE TABLE `tenant_power` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `current_kw` double NOT NULL DEFAULT 0,
  `status` enum('connected','disconnected') DEFAULT 'disconnected',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tenant_power`
--

INSERT INTO `tenant_power` (`id`, `tenant_id`, `current_kw`, `status`, `updated_at`) VALUES
(25, 22, 96.42, 'connected', '2025-06-25 19:35:44'),
(27, 24, 8.490909090909092, 'connected', '2025-06-25 19:32:08');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `charge` double NOT NULL,
  `kw` double NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `tenant_id`, `charge`, `kw`, `created_at`) VALUES
(46, 22, 1000, 2, '2025-06-25 14:44:28'),
(47, 24, 1000, 2, '2025-06-25 14:44:28'),
(48, 22, 500, 1, '2025-06-25 14:45:40'),
(49, 24, 23, 0.046, '2025-06-25 16:45:24'),
(50, 22, 23, 0.046, '2025-06-25 16:47:17'),
(51, 22, 123, 0.246, '2025-06-25 16:48:52'),
(52, 22, 123, 0.246, '2025-06-25 17:14:22'),
(53, 22, 234, 0.468, '2025-06-25 18:00:49'),
(54, 22, 55, 0.11, '2025-06-25 18:43:41'),
(55, 22, 112, 0.224, '2025-06-25 18:46:08'),
(56, 22, 21, 0.042, '2025-06-25 20:41:44'),
(57, 22, 86, 0.172, '2025-06-25 20:42:27'),
(58, 22, 23, 0.046, '2025-06-25 21:05:19'),
(59, 22, 12, 0.024, '2025-06-25 21:06:48'),
(60, 22, 3, 0.006, '2025-06-25 21:08:13'),
(61, 22, 44, 0.088, '2025-06-25 21:10:57'),
(62, 22, 13, 0.026, '2025-06-25 21:14:26'),
(63, 22, 13, 0.026, '2025-06-25 21:15:32'),
(64, 22, 13, 0.026, '2025-06-25 21:15:54'),
(65, 22, 13, 0.026, '2025-06-25 21:16:00'),
(66, 22, 13, 0.026, '2025-06-25 21:16:36'),
(67, 22, 13, 0.026, '2025-06-25 21:16:49'),
(68, 22, 13, 0.026, '2025-06-25 21:17:01'),
(69, 24, 23, 0.046, '2025-06-25 21:17:15'),
(70, 22, 21, 0.042, '2025-06-25 21:19:24'),
(71, 24, 32, 0.064, '2025-06-25 21:19:39'),
(73, 22, 23, 43, '2025-06-25 21:26:04'),
(74, 24, 20, 2.090909090909091, '2025-06-25 21:32:08'),
(75, 22, 20, 0.04, '2025-06-25 21:32:27'),
(76, 22, 20, 0.04, '2025-06-25 21:32:29'),
(77, 22, 20, 0.04, '2025-06-25 21:32:30'),
(78, 22, 20, 0.04, '2025-06-25 21:32:31'),
(79, 22, 50, 0.1, '2025-06-25 21:34:37'),
(80, 22, 10, 0.02, '2025-06-25 21:35:44');

--
-- Triggers `transactions`
--
DELIMITER $$
CREATE TRIGGER `update_tenant_power` AFTER INSERT ON `transactions` FOR EACH ROW BEGIN
    DECLARE new_kw DECIMAL(10,2);
    DECLARE new_status ENUM('connected', 'disconnected');

    -- Calculate new power
    IF EXISTS (SELECT 1 FROM tenant_power WHERE tenant_id = NEW.tenant_id) THEN
        -- Add to existing power
        SELECT current_kw + NEW.kw INTO new_kw FROM tenant_power WHERE tenant_id = NEW.tenant_id;
        SET new_status = IF(new_kw > 0, 'connected', 'disconnected');
        
        UPDATE tenant_power
        SET current_kw = new_kw, status = new_status
        WHERE tenant_id = NEW.tenant_id;

    ELSE
        -- First power record for this tenant
        SET new_kw = NEW.kw;
        SET new_status = IF(new_kw > 0, 'connected', 'disconnected');

        INSERT INTO tenant_power (tenant_id, current_kw, status)
        VALUES (NEW.tenant_id, new_kw, new_status);
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cashpower`
--
ALTER TABLE `cashpower`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `landlords`
--
ALTER TABLE `landlords`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `landlord_id` (`landlord_id`);

--
-- Indexes for table `tenant_power`
--
ALTER TABLE `tenant_power`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cashpower`
--
ALTER TABLE `cashpower`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `landlords`
--
ALTER TABLE `landlords`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tenant_power`
--
ALTER TABLE `tenant_power`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tenants`
--
ALTER TABLE `tenants`
  ADD CONSTRAINT `tenants_ibfk_1` FOREIGN KEY (`landlord_id`) REFERENCES `landlords` (`id`);

--
-- Constraints for table `tenant_power`
--
ALTER TABLE `tenant_power`
  ADD CONSTRAINT `tenant_power_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
