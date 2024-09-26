-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 26, 2024 at 06:37 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pleeartdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `cart_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `jumlah` int(11) NOT NULL,
  PRIMARY KEY (`cart_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `custom_design`
--

CREATE TABLE `custom_design` (
  `custom_design_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `template_design` blob DEFAULT NULL,
  PRIMARY KEY (`custom_design_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `tanggal_pemesanan` timestamp NOT NULL DEFAULT current_timestamp(),
  `status_pemesanan` enum('perludibayar','terkirim','dikemas','selesai','dibatalkan','perludikirim') DEFAULT 'perludibayar',
  `total_harga` decimal(10,2) NOT NULL,
  `metode_pembayaran` enum('transfer bank','e-wallet','lainnya') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `jumlah_order` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_order_item` decimal(10,2) NOT NULL,
  PRIMARY KEY (`detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `payment_status` enum('pending','success','failed') DEFAULT 'pending',
  `payment_type` varchar(50) DEFAULT NULL,
  `gross_amount` decimal(10,2) NOT NULL,
  `transaction_time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `nama_produk` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga_product` decimal(10,2) NOT NULL,
  `harga` decimal(10,2) NOT NULL,
  `gambar_satu` longblob DEFAULT NULL,
  `gambar_dua` longblob DEFAULT NULL,
  `gambar_tiga` longblob DEFAULT NULL,
  `kategori` varchar(50) NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shipments`
--

CREATE TABLE `shipments` (
  `shipment_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `ekspedisi` varchar(50) NOT NULL,
  `nomor_resi` varchar(50) DEFAULT NULL,
  `status_pengiriman` enum('dalam perjalanan','diterima') DEFAULT NULL,
  `tanggal_pengiriman` date DEFAULT NULL,
  `alamat_pengiriman` text NOT NULL,
  PRIMARY KEY (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `nama_lengkap` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(256) NOT NULL,
  `alamat` text NOT NULL,
  `nomor_telepon` varchar(20) DEFAULT NULL,
  `jenis_pengguna` enum('admin','customer') NOT NULL DEFAULT 'customer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

-- Indexes for table `carts`
ALTER TABLE `carts`
  ADD CONSTRAINT `FK_carts_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

-- Indexes for table `custom_design`
ALTER TABLE `custom_design`
  ADD CONSTRAINT `FK_custom_design_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `FK_custom_design_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

-- Indexes for table `orders`
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

-- Indexes for table `order_items`
ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

-- Indexes for table `payments`
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

-- Indexes for table `shipments`
ALTER TABLE `shipments`
  ADD CONSTRAINT `shipments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
