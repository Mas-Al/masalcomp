-- phpMyAdmin SQL Dump
-- version 4.8.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 10, 2023 at 09:22 PM
-- Server version: 10.1.32-MariaDB
-- PHP Version: 5.6.36

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbmasalcomp`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `jmlPenghasilan` (`tanggal_awal` DATETIME, `tanggal_akhir` DATETIME) RETURNS INT(11) BEGIN 
	DECLARE jmlHasil INT;
	SELECT sum(
			(
			((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) - 
			(((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) * transaksi.diskon / 100)
			) 
			+ 
			((
			(((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) - 
			(((paket.harga_paket * detail_transaksi.kuantitas) + transaksi.biaya_tambahan) * transaksi.diskon / 100)) 
			* transaksi.pajak
			) / 100)
		) as penghasilan INTO jmlHasil
		FROM transaksi
		INNER JOIN user ON transaksi.id_user = user.id_user 
		INNER JOIN member ON transaksi.id_member = member.id_member 
		INNER JOIN detail_transaksi ON transaksi.id_transaksi = detail_transaksi.id_transaksi 
		INNER JOIN paket ON detail_transaksi.id_paket = paket.id_paket 
		INNER JOIN jenis_paket ON paket.id_jenis_paket = jenis_paket.id_jenis_paket 
		INNER JOIN outlet ON transaksi.id_outlet = outlet.id_outlet WHERE transaksi.tanggal_transaksi 
		BETWEEN tanggal_awal AND tanggal_akhir;
	RETURN jmlHasil;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `jmlStatusTanggal` (`st` ENUM('proses','dicuci','siap diambil','sudah diambil'), `tgl` DATE) RETURNS INT(11) NO SQL
BEGIN
DECLARE jmlHasil INT;
SELECT COUNT(*) AS jml INTO jmlHasil FROM transaksi WHERE status_transaksi = st AND date(tanggal_transaksi) = tgl;
RETURN jmlHasil;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `jmlTransPaket` (`idPaket` INT) RETURNS INT(11) BEGIN
DECLARE jmlHasil INT;
	SELECT COUNT(*) as jml INTO jmlHasil FROM detail_transaksi WHERE id_paket = idPaket;
    RETURN jmlHasil;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `biodata`
--

CREATE TABLE `biodata` (
  `id_biodata` int(11) NOT NULL,
  `nama_lengkap` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tempat_lahir` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `jenis_kelamin` enum('pria','wanita') COLLATE utf8_unicode_ci NOT NULL,
  `golongan_darah` enum('o','a','b','ab') COLLATE utf8_unicode_ci DEFAULT NULL,
  `telepon` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `alamat` text COLLATE utf8_unicode_ci NOT NULL,
  `foto` text COLLATE utf8_unicode_ci NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `biodata`
--

INSERT INTO `biodata` (`id_biodata`, `nama_lengkap`, `tempat_lahir`, `tanggal_lahir`, `jenis_kelamin`, `golongan_darah`, `telepon`, `email`, `alamat`, `foto`, `id_user`) VALUES
(1, 'Abdurrohman Al-Faiz', 'Lamongan', '2002-05-30', 'pria', 'o', '081333258045', 'masal.3005@gmail.com', 'Tikung,Lamongan', 'IMG_20221105_212831.jpg', 1),
(2, 'Andre Setyawan', 'Lamongan', '2002-01-29', 'pria', '', '08123456789', 'andre@gmail.com', 'Jl. paciran', 'andre.jpg', 2),
(3, 'wahyu zu fahim', 'Malaysia', '2002-08-28', 'pria', 'o', '081234567678', 'wahyu@gmail.com', 'laren', 'wahyu.jpg', 3),
(4, 'M. FAIZ KURNIAWAN', 'LAMONGAN', '2002-08-09', 'pria', '', '08123456789', 'wahyu@gmail.com', 'JL. kedungpring', 'default.png', 4),
(5, 'Bayu Putra Ramadhan', 'LAMONGAN', '1995-01-11', 'pria', '', '1234567890', 'bayu@gmail.com', 'lamongan', 'default.png', 5);

-- --------------------------------------------------------

--
-- Table structure for table `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `id_detail_transaksi` int(11) NOT NULL,
  `kuantitas` float NOT NULL,
  `keterangan` text COLLATE utf8_unicode_ci NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `id_paket` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`id_detail_transaksi`, `kuantitas`, `keterangan`, `id_transaksi`, `id_paket`) VALUES
(64, 4, 'kemeja', 45, 2),
(65, 1, '', 46, 1),
(66, 1, '1', 47, 1),
(68, 3, 'INSTALL WINDOWS', 49, 8),
(69, 1, 'mati', 50, 8),
(70, 1, '', 51, 8);

-- --------------------------------------------------------

--
-- Table structure for table `jabatan`
--

CREATE TABLE `jabatan` (
  `id_jabatan` int(11) NOT NULL,
  `nama_jabatan` varchar(100) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `jabatan`
--

INSERT INTO `jabatan` (`id_jabatan`, `nama_jabatan`) VALUES
(1, 'FOUNDER'),
(2, 'Admin'),
(3, 'Teknisi'),
(4, 'owner');

-- --------------------------------------------------------

--
-- Table structure for table `jenis_paket`
--

CREATE TABLE `jenis_paket` (
  `id_jenis_paket` int(11) NOT NULL,
  `nama_jenis_paket` varchar(100) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `jenis_paket`
--

INSERT INTO `jenis_paket` (`id_jenis_paket`, `nama_jenis_paket`) VALUES
(1, 'LAPTOP'),
(2, 'KOMPUTER'),
(3, 'GANTI SPAREPART');

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `id_log` int(11) NOT NULL,
  `isi_log` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tanggal_log` datetime NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `log`
--

INSERT INTO `log` (`id_log`, `isi_log`, `tanggal_log`, `id_user`) VALUES
(1075, 'Transaksi  berhasil dihapus', '2023-07-10 21:29:53', 2),
(1076, 'Transaksi 10072023126T0001 berhasil ditambahkan', '2023-07-10 21:31:46', 2),
(1077, 'Detail Transaksi 10072023126T0001 berhasil ditambahkan', '2023-07-10 21:31:54', 2),
(1078, 'Pembayaran Transaksi 10072023126T0001 berhasil', '2023-07-10 21:32:13', 2),
(1079, 'Transaksi  berhasil diubah status transaksinya', '2023-07-10 21:32:44', 2),
(1080, 'Transaksi  berhasil diubah status transaksinya', '2023-07-10 21:32:49', 2),
(1081, 'Pengguna ADMIN berhasil logout', '2023-07-10 21:34:24', 2),
(1082, 'Pengguna super_administrator berhasil login', '2023-07-10 21:34:37', 1),
(1083, 'Transaksi  berhasil diubah status transaksinya', '2023-07-10 21:34:45', 1),
(1084, 'Pengguna febyfeb09 berhasil dihapus', '2023-07-10 21:52:39', 1),
(1085, 'Member Tyo Hafiad Noerman berhasil dihapus', '2023-07-10 21:53:00', 1),
(1086, 'Member Roro Dana Iswara Aditya Bakti berhasil dihapus', '2023-07-10 21:53:09', 1),
(1087, 'Member Nazira Apriliani berhasil dihapus', '2023-07-10 21:53:16', 1),
(1088, 'Member Andre berhasil ditambahkan', '2023-07-10 21:54:01', 1),
(1089, 'Transaksi 100720231119T0002 berhasil ditambahkan', '2023-07-10 21:54:15', 1),
(1090, 'Detail Transaksi 100720231119T0002 berhasil ditambahkan', '2023-07-10 21:54:21', 1),
(1091, 'Transaksi 100720231119T0002 berhasil dihapus', '2023-07-10 21:54:38', 1),
(1092, 'Member Rayhan Aditya Syahputra berhasil dihapus', '2023-07-10 21:56:01', 1),
(1093, 'Paket PAKET LOW berhasil ditambahkan', '2023-07-10 21:57:44', 1),
(1094, 'Paket PAKET LOW berhasil dihapus', '2023-07-10 21:57:50', 1),
(1095, 'Jabatan Admin berhasil diubah', '2023-07-10 21:58:21', 1),
(1096, 'Jabatan Teknisi berhasil diubah', '2023-07-10 21:58:31', 1),
(1097, 'Pengguna super_administrator berhasil logout', '2023-07-10 22:12:07', 1),
(1098, 'Pengguna pemilik berhasil login', '2023-07-10 22:37:23', 1),
(1099, 'Pengguna pemilik berhasil logout', '2023-07-10 23:00:45', 1),
(1100, 'Pengguna ADMIN berhasil login', '2023-07-10 23:00:55', 2),
(1101, 'Paket PAKET LOW berhasil ditambahkan', '2023-07-10 23:04:46', 2),
(1102, 'Member Faiz K berhasil ditambahkan', '2023-07-10 23:06:22', 2),
(1103, 'Transaksi 100720231220T0001 berhasil ditambahkan', '2023-07-10 23:06:37', 2),
(1104, 'Detail Transaksi 100720231220T0001 berhasil ditambahkan', '2023-07-10 23:07:03', 2),
(1105, 'Pengguna owner berhasil diubah', '2023-07-10 23:09:44', 2),
(1106, 'Paket PAKET MEDIUM berhasil ditambahkan', '2023-07-10 23:11:47', 2),
(1107, 'Paket PAKET HIGH berhasil ditambahkan', '2023-07-10 23:12:08', 2),
(1108, 'Transaksi  berhasil diubah status transaksinya', '2023-07-10 23:15:33', 2),
(1109, 'Pengguna ADMIN berhasil logout', '2023-07-10 23:18:01', 2),
(1110, 'Pengguna pemilik berhasil login', '2023-07-10 23:18:08', 1),
(1111, 'Transaksi 100720231120T0002 berhasil ditambahkan', '2023-07-10 23:18:21', 1),
(1112, 'Detail Transaksi 100720231120T0002 berhasil ditambahkan', '2023-07-10 23:18:30', 1),
(1113, 'Transaksi  berhasil diubah status transaksinya', '2023-07-10 23:18:38', 1),
(1114, 'Transaksi 100720231120T0001 berhasil ditambahkan', '2023-07-10 23:22:56', 1),
(1115, 'Detail Transaksi 100720231120T0001 berhasil ditambahkan', '2023-07-10 23:23:01', 1),
(1116, 'Pembayaran Transaksi 100720231120T0001 berhasil', '2023-07-10 23:23:15', 1),
(1117, 'Transaksi  berhasil diubah status transaksinya', '2023-07-10 23:23:23', 1),
(1118, 'Pengguna pemilik berhasil logout', '2023-07-10 23:34:51', 1),
(1119, 'Pengguna TEKNISI berhasil login', '2023-07-10 23:36:08', 3),
(1120, 'Pengguna TEKNISI berhasil logout', '2023-07-10 23:36:49', 3),
(1121, 'Pengguna owner berhasil login', '2023-07-10 23:36:55', 4),
(1122, 'Pengguna owner berhasil logout', '2023-07-10 23:37:20', 4),
(1123, 'Pengguna pemilik berhasil login', '2023-07-10 23:37:27', 1),
(1124, 'Pengguna owner berhasil diubah', '2023-07-10 23:37:39', 1),
(1125, 'Pengguna pemilik berhasil logout', '2023-07-10 23:37:44', 1),
(1126, 'Pengguna owner berhasil login', '2023-07-10 23:37:50', 4),
(1127, 'Pengguna owner berhasil logout', '2023-07-10 23:38:45', 4),
(1128, 'Pengguna ADMIN berhasil login', '2023-07-10 23:38:50', 2),
(1129, 'Pengguna ADMIN berhasil logout', '2023-07-10 23:39:16', 2),
(1130, 'Pengguna TEKNISI berhasil login', '2023-07-10 23:39:22', 3),
(1131, 'Transaksi  berhasil diubah status transaksinya', '2023-07-10 23:40:07', 3),
(1132, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-10 23:41:07', 3),
(1133, 'Transaksi 100720231120T0001 berhasil diubah', '2023-07-10 23:41:34', 3),
(1134, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-10 23:41:38', 3),
(1135, 'Pengguna TEKNISI berhasil logout', '2023-07-10 23:42:24', 3),
(1136, 'Pengguna ADMIN berhasil login', '2023-07-10 23:42:29', 2),
(1137, 'Member Wahyu berhasil ditambahkan', '2023-07-11 00:20:24', 2),
(1138, 'Transaksi 110720231221T0001 berhasil ditambahkan', '2023-07-11 00:21:23', 2),
(1139, 'Detail Transaksi 110720231221T0001 berhasil ditambahkan', '2023-07-11 00:22:03', 2),
(1140, 'Cetak Laporan - 2023-07-01 00:00:00 - 2023-07-11 23:59:59', '2023-07-11 00:29:31', 2),
(1141, 'Transaksi  berhasil diubah status transaksinya', '2023-07-11 00:30:01', 2),
(1142, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-11 00:30:09', 2),
(1143, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-11 00:31:05', 2),
(1144, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-11 00:31:47', 2),
(1145, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-11 00:31:54', 2),
(1146, 'Pengguna ADMIN berhasil logout', '2023-07-11 00:33:00', 2),
(1147, 'Pengguna ADMIN berhasil login', '2023-07-11 00:44:27', 2),
(1148, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-11 00:44:33', 2),
(1149, 'Pengguna ADMIN berhasil logout', '2023-07-11 02:02:05', 2),
(1150, 'Pengguna pemilik berhasil login', '2023-07-11 02:02:12', 1),
(1151, 'Biodata Pengguna pemilik berhasil diubah', '2023-07-11 02:04:39', 1),
(1152, 'Biodata Pengguna pemilik berhasil diubah', '2023-07-11 02:06:16', 1),
(1153, 'Biodata Pengguna pemilik berhasil diubah', '2023-07-11 02:07:09', 1),
(1154, 'Biodata Pengguna pemilik berhasil diubah', '2023-07-11 02:08:17', 1),
(1155, 'Pengguna TEKNISI_1 berhasil ditambahkan', '2023-07-11 02:09:24', 1),
(1156, 'Biodata Pengguna Bayu Putra Ramadhan berhasil ditambahkan', '2023-07-11 02:10:28', 1),
(1157, 'Pengguna owner berhasil diubah', '2023-07-11 02:11:13', 1),
(1158, 'Pengguna pemilik berhasil logout', '2023-07-11 02:11:42', 1),
(1159, 'Pengguna owner berhasil login', '2023-07-11 02:11:50', 4),
(1160, 'Pengguna owner berhasil logout', '2023-07-11 02:12:37', 4),
(1161, 'Pengguna ADMIN berhasil login', '2023-07-11 02:12:53', 2),
(1162, 'Transaksi 110720231221T0001 berhasil dihapus', '2023-07-11 02:13:25', 2),
(1163, 'Transaksi  berhasil diubah status transaksinya', '2023-07-11 02:13:38', 2),
(1164, 'Transaksi  berhasil diubah status transaksinya', '2023-07-11 02:13:44', 2),
(1165, 'Cetak Invoice - 100720231120T0001 - Faiz K', '2023-07-11 02:15:06', 2);

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id_member` int(11) NOT NULL,
  `nama_member` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `jenis_kelamin` enum('pria','wanita') COLLATE utf8_unicode_ci NOT NULL,
  `telepon_member` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `email_member` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `alamat_member` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`id_member`, `nama_member`, `jenis_kelamin`, `telepon_member`, `email_member`, `alamat_member`) VALUES
(20, 'Faiz K', 'pria', '123456', 'FAIK@GMAIL.COM', 'LAREN'),
(21, 'Wahyu', 'pria', '12345', 'FAIK@GMAIL.COM', 'laren');

-- --------------------------------------------------------

--
-- Table structure for table `outlet`
--

CREATE TABLE `outlet` (
  `id_outlet` int(11) NOT NULL,
  `nama_outlet` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `telepon_outlet` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `alamat_outlet` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `outlet`
--

INSERT INTO `outlet` (`id_outlet`, `nama_outlet`, `telepon_outlet`, `alamat_outlet`) VALUES
(1, 'MAS AL COMP', '081333258045', 'Jl. Pule, Pulo, Bakalanpule, dsn.pule, Kabupaten Lamongan, Jawa Timur 62281'),
(2, 'MAS AL COMP 2', '081230620840', 'LAMONGREJO,LAMONGAN');

-- --------------------------------------------------------

--
-- Table structure for table `paket`
--

CREATE TABLE `paket` (
  `id_paket` int(11) NOT NULL,
  `nama_paket` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `harga_paket` int(11) NOT NULL,
  `id_outlet` int(11) NOT NULL,
  `id_jenis_paket` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `paket`
--

INSERT INTO `paket` (`id_paket`, `nama_paket`, `harga_paket`, `id_outlet`, `id_jenis_paket`) VALUES
(8, 'PAKET LOW', 10000, 1, 1),
(9, 'PAKET MEDIUM', 50000, 1, 2),
(10, 'PAKET HIGH', 50000, 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_pembayaran` int(11) NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `total_harga` int(11) NOT NULL,
  `uang_yg_dibayar` int(11) NOT NULL,
  `kembalian` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`id_pembayaran`, `id_transaksi`, `id_user`, `total_harga`, `uang_yg_dibayar`, `kembalian`) VALUES
(30, 47, 2, 8800, 10000, 1200),
(31, 51, 1, 20200, 21000, 800);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `kode_invoice` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tanggal_transaksi` datetime NOT NULL,
  `batas_waktu` datetime NOT NULL,
  `tanggal_bayar` datetime NOT NULL,
  `biaya_tambahan` int(11) NOT NULL,
  `diskon` float NOT NULL,
  `pajak` int(11) NOT NULL,
  `status_transaksi` enum('proses','diservice','siap diambil','sudah diambil') COLLATE utf8_unicode_ci NOT NULL,
  `status_bayar` enum('belum dibayar','sudah dibayar') COLLATE utf8_unicode_ci NOT NULL,
  `id_member` int(11) NOT NULL,
  `id_outlet` int(11) NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `kode_invoice`, `tanggal_transaksi`, `batas_waktu`, `tanggal_bayar`, `biaya_tambahan`, `diskon`, `pajak`, `status_transaksi`, `status_bayar`, `id_member`, `id_outlet`, `id_user`) VALUES
(51, '100720231120T0001', '2023-07-10 23:22:56', '2023-07-10 23:22:00', '2023-07-10 23:23:15', 0, 0, 0, 'sudah diambil', 'sudah dibayar', 20, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `id_outlet` int(11) NOT NULL,
  `id_jabatan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `username`, `password`, `id_outlet`, `id_jabatan`) VALUES
(1, 'pemilik', '$2y$10$.zk2CNXlXauzDhI38F721.2ExLvw3hvDxE4hA.v/m.ANSGrPiPleC', 1, 1),
(2, 'ADMIN', '$2y$10$pFEavlHoN3M8NqpoW.XfGOZ7lBnWngElDkijqaBoAs4uwEpS1HrBq', 1, 2),
(3, 'TEKNISI', '$2y$10$z6U4gqlXkVHxVn9DeR5wveVUPvkWcscdODMoK4Xdzcj256mkbg666', 1, 3),
(4, 'owner', '$2y$10$LLS4fpdOsBbDjFjHwtEh3OwsFNILOAOJ6JEGga3zE1HupDLq/7wpa', 2, 3),
(5, 'TEKNISI_1', '$2y$10$.NUs3Kpy4kTMS1hjt2RNMeII7XN0u2M.aFAmUpdpqm8du8RQGFLgq', 1, 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `biodata`
--
ALTER TABLE `biodata`
  ADD PRIMARY KEY (`id_biodata`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`id_detail_transaksi`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_paket` (`id_paket`);

--
-- Indexes for table `jabatan`
--
ALTER TABLE `jabatan`
  ADD PRIMARY KEY (`id_jabatan`);

--
-- Indexes for table `jenis_paket`
--
ALTER TABLE `jenis_paket`
  ADD PRIMARY KEY (`id_jenis_paket`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`id_member`);

--
-- Indexes for table `outlet`
--
ALTER TABLE `outlet`
  ADD PRIMARY KEY (`id_outlet`);

--
-- Indexes for table `paket`
--
ALTER TABLE `paket`
  ADD PRIMARY KEY (`id_paket`),
  ADD KEY `id_outlet` (`id_outlet`),
  ADD KEY `id_jenis_paket` (`id_jenis_paket`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_pembayaran`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_member` (`id_member`),
  ADD KEY `id_outlet` (`id_outlet`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `id_outlet` (`id_outlet`),
  ADD KEY `id_jabatan` (`id_jabatan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `biodata`
--
ALTER TABLE `biodata`
  MODIFY `id_biodata` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `id_detail_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `jabatan`
--
ALTER TABLE `jabatan`
  MODIFY `id_jabatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `jenis_paket`
--
ALTER TABLE `jenis_paket`
  MODIFY `id_jenis_paket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1166;

--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `id_member` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `outlet`
--
ALTER TABLE `outlet`
  MODIFY `id_outlet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `paket`
--
ALTER TABLE `paket`
  MODIFY `id_paket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_pembayaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `biodata`
--
ALTER TABLE `biodata`
  ADD CONSTRAINT `biodata_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `detail_transaksi_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detail_transaksi_ibfk_2` FOREIGN KEY (`id_paket`) REFERENCES `paket` (`id_paket`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `log`
--
ALTER TABLE `log`
  ADD CONSTRAINT `log_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `paket`
--
ALTER TABLE `paket`
  ADD CONSTRAINT `paket_ibfk_1` FOREIGN KEY (`id_jenis_paket`) REFERENCES `jenis_paket` (`id_jenis_paket`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `paket_ibfk_2` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `pembayaran_ibfk_2` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_3` FOREIGN KEY (`id_member`) REFERENCES `member` (`id_member`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`id_jabatan`) REFERENCES `jabatan` (`id_jabatan`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
