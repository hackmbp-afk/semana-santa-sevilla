/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.7.2-MariaDB, for Win64 (AMD64)
--
-- Host: 192.168.59.134    Database: Semana_Santa
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `cofradias`
--

DROP TABLE IF EXISTS `cofradias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cofradias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `dia_salida` varchar(50) DEFAULT NULL,
  `id_hermandad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cofradias_hermandades` (`id_hermandad`),
  CONSTRAINT `fk_cofradias_hermandades` FOREIGN KEY (`id_hermandad`) REFERENCES `hermandades` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cofradias`
--

LOCK TABLES `cofradias` WRITE;
/*!40000 ALTER TABLE `cofradias` DISABLE KEYS */;
INSERT INTO `cofradias` VALUES
(1,'La Macarena','Madrugá',1),
(2,'Esperanza de Triana','Viernes Santo',2),
(3,'Gran Poder','Madrugá',3),
(4,'Los Gitanos','Madrugá',4);
/*!40000 ALTER TABLE `cofradias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventos`
--

DROP TABLE IF EXISTS `eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `id_hermandad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_eventos_hermandades` (`id_hermandad`),
  CONSTRAINT `fk_eventos_hermandades` FOREIGN KEY (`id_hermandad`) REFERENCES `hermandades` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventos`
--

LOCK TABLES `eventos` WRITE;
/*!40000 ALTER TABLE `eventos` DISABLE KEYS */;
INSERT INTO `eventos` VALUES
(1,'Salida procesional Macarena','2026-04-03',1),
(2,'Salida Esperanza de Triana','2026-04-04',2),
(3,'Salida Gran Poder','2026-04-03',3);
/*!40000 ALTER TABLE `eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hermandades`
--

DROP TABLE IF EXISTS `hermandades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hermandades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `barrio` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hermandades`
--

LOCK TABLES `hermandades` WRITE;
/*!40000 ALTER TABLE `hermandades` DISABLE KEYS */;
INSERT INTO `hermandades` VALUES
(1,'Hermandad de la Macarena','Macarena'),
(2,'Hermandad de Triana','Triana'),
(3,'Hermandad del Gran Poder','San Lorenzo'),
(4,'Hermandad de Los Gitanos','Centro');
/*!40000 ALTER TABLE `hermandades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pasos`
--

DROP TABLE IF EXISTS `pasos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pasos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `estilo` varchar(50) DEFAULT NULL,
  `id_cofradia` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pasos_cofradias` (`id_cofradia`),
  CONSTRAINT `fk_pasos_cofradias` FOREIGN KEY (`id_cofradia`) REFERENCES `cofradias` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasos`
--

LOCK TABLES `pasos` WRITE;
/*!40000 ALTER TABLE `pasos` DISABLE KEYS */;
INSERT INTO `pasos` VALUES
(1,'Jesús de la Sentencia','Neobarroco',1),
(2,'Virgen de la Esperanza Macarena','Barroco',1),
(3,'Cristo del Gran Poder','Barroco',3),
(4,'Virgen de las Angustias','Barroco',3);
/*!40000 ALTER TABLE `pasos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recorridos`
--

DROP TABLE IF EXISTS `recorridos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `recorridos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` text DEFAULT NULL,
  `id_cofradia` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_recorridos_cofradias` (`id_cofradia`),
  CONSTRAINT `fk_recorridos_cofradias` FOREIGN KEY (`id_cofradia`) REFERENCES `cofradias` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recorridos`
--

LOCK TABLES `recorridos` WRITE;
/*!40000 ALTER TABLE `recorridos` DISABLE KEYS */;
INSERT INTO `recorridos` VALUES
(1,'Salida desde San Gil, Campana, Catedral',1),
(2,'Triana, Puente Isabel II, Carrera Oficial',2),
(3,'San Lorenzo, Plaza del Duque, Catedral',3);
/*!40000 ALTER TABLE `recorridos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'Semana_Santa'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-29 20:42:40
