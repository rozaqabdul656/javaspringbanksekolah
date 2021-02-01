-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 01, 2021 at 02:29 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_bank_sekolah`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `hapusanggota` (`a` CHAR(11))  begin
	delete from tb_setoran where nim=a;
	delete from tb_penarikan where nim=a;
	delete from tb_saldo where nim=a;
	delete from tb_pinjaman where nim=a;
	delete from tb_pembayaran where nim=a;
	delete from tb_saldo_peminjaman where nim=a;
	delete from tb_anggota where nim=a;
	
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hapuspinjaman` (`a` CHAR(11))  begin
	delete from tb_pinjaman where nim=a;
	delete from tb_saldo_peminjaman where nim=a;
	
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_admin`
--

CREATE TABLE `tb_admin` (
  `kode_admin` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_admin`
--

INSERT INTO `tb_admin` (`kode_admin`) VALUES
('admin');

-- --------------------------------------------------------

--
-- Table structure for table `tb_anggota`
--

CREATE TABLE `tb_anggota` (
  `nim` char(11) NOT NULL,
  `nama` varchar(40) NOT NULL,
  `jenis_kelamin` varchar(25) NOT NULL,
  `tanggal` date NOT NULL,
  `alamat` varchar(40) NOT NULL,
  `kelas` varchar(10) NOT NULL,
  `saldo_awal` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_anggota`
--

INSERT INTO `tb_anggota` (`nim`, `nama`, `jenis_kelamin`, `tanggal`, `alamat`, `kelas`, `saldo_awal`) VALUES
('12312312311', 'THANOS', 'Perempuan', '2019-01-03', 'JALAN DAKOTA', '7 - G', 0),
('12312312312', 'FIAS', 'laki-laki', '2019-01-02', 'CIMAHI', '7 - A', 10000),
('12324324324', 'Terserah ', 'laki-laki', '2019-08-28', 'Terserah ', '7 - A', 100000),
('1234561123', 'updated sukses', 'laki-laki', '2019-01-08', 'Bandung', '7 - A', 10000),
('21231231231', 'Bayi Thanos', 'laki-laki', '2019-01-10', 'Jalan Dakota 8a', '7 - B', 10000),
('21232321232', 'Iron man', 'laki-laki', '2019-01-09', 'Jalan dakota', '7 - B', 10000),
('22222222222', 'RADAASDSDDS', 'laki-laki', '2019-08-03', 'BANDUNG ', '7 - A', 0),
('23122312312', 'KUYa', 'laki-laki', '2019-08-02', 'Banjarnegara', '7 - B', 10),
('23324223423', 'Thanos', 'laki-laki', '2019-01-01', 'asdasdasdsadadadadaddad', '7 - S', 1),
('32345443443', 'Spiderman', 'laki-laki', '2019-01-03', 'Bandung ', '7 - B', 10990),
('32345656897', 'Mickey', 'laki-laki', '2019-01-03', 'Cimahi', '7 - A', 20000),
('34349098987', 'ASD ', 'Perempuan', '2019-09-06', 'BANDUNG', '7 - A', 1),
('56554565454', 'Hasi', 'laki-laki', '2019-01-08', 'Bandung', '7 - A', 10000),
('77777777777', 'DUMY DATA', 'laki-laki', '2019-08-06', 'mn', '8 - Z', 80);

--
-- Triggers `tb_anggota`
--
DELIMITER $$
CREATE TRIGGER `nambah_anggota` AFTER INSERT ON `tb_anggota` FOR EACH ROW begin
	declare total bigint;
    insert into tb_saldo values(' ',new.nim,new.tanggal,'Saldo Awal ',new.saldo_awal,' ',new.saldo_awal);
	
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_penarikan`
--

CREATE TABLE `tb_penarikan` (
  `id` varchar(255) NOT NULL,
  `besar_penarikan` varchar(255) DEFAULT NULL,
  `nim` varchar(255) DEFAULT NULL,
  `tanggal_penarikan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_penarikan`
--

INSERT INTO `tb_penarikan` (`id`, `besar_penarikan`, `nim`, `tanggal_penarikan`) VALUES
('', '10', '77777777777', '2020-08-06');

--
-- Triggers `tb_penarikan`
--
DELIMITER $$
CREATE TRIGGER `penarikan` AFTER INSERT ON `tb_penarikan` FOR EACH ROW begin
	declare total bigint;
	SELECT saldo into total FROM tb_saldo where nim=new.nim ORDER BY id DESC  LIMIT 0,1 ;
	insert into tb_saldo (nim,tanggal,keterangan,kredit,saldo) values(new.nim,new.tanggal_penarikan,"Penarikan",new.besar_penarikan,total-new.besar_penarikan);
	update tb_anggota set saldo_awal=total-new.besar_penarikan where nim=new.nim;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_saldo`
--

CREATE TABLE `tb_saldo` (
  `id` int(11) NOT NULL,
  `nim` char(11) NOT NULL,
  `tanggal` varchar(30) NOT NULL,
  `keterangan` varchar(30) NOT NULL,
  `debit` bigint(20) DEFAULT 0,
  `kredit` bigint(20) NOT NULL,
  `saldo` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tb_saldo`
--

INSERT INTO `tb_saldo` (`id`, `nim`, `tanggal`, `keterangan`, `debit`, `kredit`, `saldo`) VALUES
(0, '1234561123', '2019-01-08', 'Saldo Awal ', 10000, 0, 10000),
(28, '21231231231', '2019-01-10', 'Saldo Awal ', 10000, 0, 10000),
(29, '21232321232', '2019-01-09', 'Saldo Awal ', 10000, 0, 10000),
(30, '32345443443', '2019-01-03', 'Saldo Awal ', 10000, 0, 10000),
(34, '21232321232', '2019-01-02', 'Setoran Tabungan', 89, 0, 10089),
(35, '32345443443', '2019-01-02', 'Setoran Tabungan', 90, 0, 10090),
(37, '21232321232', '2019-01-02', 'Penarikan', 0, 89, 10000),
(39, '12312312312', '2019-01-02', 'Saldo Awal ', 1, 0, 1),
(40, '23324223423', '2019-01-01', 'Saldo Awal ', 1, 0, 1),
(41, '12312312312', '2019-01-02', 'Penarikan', 0, 1, 0),
(42, '12312312311', '2019-01-03', 'Saldo Awal ', 10, 0, 10),
(43, '12312312311', '2019-01-02', 'Setoran Tabungan', 10, 0, 20),
(44, '12312312311', '2019-01-03', 'Setoran Tabungan', 12, 0, 32),
(45, '12312312311', '2019-01-03', 'Penarikan', 0, 10, 22),
(46, '12324324324', '2019-08-28', 'Saldo Awal ', 100000, 0, 100000),
(47, '12324324324', '2019-01-15', 'Setoran Tabungan', 100000, 0, 200000),
(48, '12324324324', '2019-01-21', 'Penarikan', 0, 100000, 100000),
(49, '12312312312', '2019-08-01', 'Setoran Tabungan', 10000, 0, 10000),
(50, '77777777777', '2019-08-06', 'Saldo Awal ', 90, 0, 90),
(51, '32345443443', '2019-08-02', 'Setoran Tabungan', 900, 0, 10990),
(52, '56554565454', '2019-01-08', 'Saldo Awal ', 10000, 0, 10000),
(53, '23122312312', '2019-08-02', 'Saldo Awal ', 10, 0, 10),
(54, '22222222222', '2019-08-03', 'Saldo Awal ', 0, 0, 0),
(55, '34349098987', '2019-09-06', 'Saldo Awal ', 1, 0, 1),
(56, '12312312311', '2019-09-06', 'Setoran Tabungan', 100, 0, 122),
(57, '12312312311', '2019-09-07', 'Penarikan', 0, 122, 0),
(58, '77777777777', '2020-08-06', 'Penarikan', 0, 10, 80);

-- --------------------------------------------------------

--
-- Table structure for table `tb_setoran`
--

CREATE TABLE `tb_setoran` (
  `id` int(11) NOT NULL,
  `besar_setoran` varchar(255) DEFAULT NULL,
  `nim` varchar(255) DEFAULT NULL,
  `tanggal_setoran` varchar(255) DEFAULT NULL,
  `tanggal` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_setoran`
--

INSERT INTO `tb_setoran` (`id`, `besar_setoran`, `nim`, `tanggal_setoran`, `tanggal`) VALUES
(1, '10000', '12312312311', '23-03-2001', NULL);

--
-- Triggers `tb_setoran`
--
DELIMITER $$
CREATE TRIGGER `setoran` AFTER INSERT ON `tb_setoran` FOR EACH ROW begin
	declare total bigint;
	SELECT saldo into total FROM tb_saldo where nim=new.nim ORDER BY id DESC  LIMIT 0,1 ;
	insert into tb_saldo (nim,tanggal,keterangan,debit,saldo) values(new.nim,new.tanggal,"Setoran Tabungan",new.besar_setoran,total+new.besar_setoran);
	update tb_anggota set saldo_awal=total+new.besar_setoran where nim=new.nim;
end
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_anggota`
--
ALTER TABLE `tb_anggota`
  ADD PRIMARY KEY (`nim`);

--
-- Indexes for table `tb_penarikan`
--
ALTER TABLE `tb_penarikan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_saldo`
--
ALTER TABLE `tb_saldo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_tb_saldo` (`nim`);

--
-- Indexes for table `tb_setoran`
--
ALTER TABLE `tb_setoran`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_saldo`
--
ALTER TABLE `tb_saldo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `tb_setoran`
--
ALTER TABLE `tb_setoran`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_saldo`
--
ALTER TABLE `tb_saldo`
  ADD CONSTRAINT `FK_tb_saldo` FOREIGN KEY (`nim`) REFERENCES `tb_anggota` (`nim`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
