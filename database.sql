-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_deynikin_exam
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('c2855292fe2a');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genre`
--

DROP TABLE IF EXISTS `book_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genre` (
  `book_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`genre_id`),
  KEY `fk_book_genre_genre_id_genres` (`genre_id`),
  CONSTRAINT `fk_book_genre_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_book_genre_genre_id_genres` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genre`
--

LOCK TABLES `book_genre` WRITE;
/*!40000 ALTER TABLE `book_genre` DISABLE KEYS */;
INSERT INTO `book_genre` VALUES (19,2),(20,2),(26,2),(15,3),(30,3),(16,4),(18,5),(25,5),(20,6),(21,7),(22,8),(26,8),(27,8),(22,9),(23,9),(28,9),(29,9),(23,10),(24,11),(25,12),(28,13);
/*!40000 ALTER TABLE `book_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `brief_description` text NOT NULL,
  `year` varchar(4) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `volume` int NOT NULL,
  `total_rating` int NOT NULL,
  `number_of_ratings` int NOT NULL,
  `image_id` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_books_image_id_images` (`image_id`),
  CONSTRAINT `fk_books_image_id_images` FOREIGN KEY (`image_id`) REFERENCES `images` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (15,'1984','Пожалуй, самый знаменитый роман ХХ века \"1984\" - это антиутопия о политической тирании, контроле над разумом, паранойе и тайной массовой слежке. Вслед за Уинстоном Смитом, прилежным референтом Министерства правды, роман рисует тревожный портрет тоталитарного режима, когда даже мысли жителей подвергаются цензуре. Это издание в твердом переплете с ярким графическим дизайном обложки, суперобложкой и соответствующими цветными обоями станет прекрасным подарком или коллекционным экземпляром этой современной классики.','1949','Secker and Warburg','Джордж Оруэлл',318,0,0,'9f8978e3-72db-442a-bb5a-c1d9899bfa61'),(16,'Убить пересмешника','Стреляйте в голубых соек, сколько хотите, если сможете попасть в них, но помните, что убивать пересмешника - грех.\n\nАдвокат Аттикус Финч дает этот совет своим детям, защищая настоящего пересмешника из классического романа Харпер Ли - чернокожего мужчину, обвиненного в изнасиловании белой девушки. Через юные глаза Скаут и Джема Финч Харпер Ли с неподдельным юмором исследует иррациональность отношения взрослых к расе и классу на глубоком Юге 1930-х годов. Совесть города, погрязшего в предрассудках, насилии и лицемерии, уязвляет стойкость одного человека, борющегося за справедливость. Но груз истории не терпит...','1960','J.B. Lippincott and Co','Харпер Ли',281,5,1,'21900a41-4f78-41af-a145-08df161be96f'),(18,'Маленький принц','Философская сказка о маленьком принце, путешествующем по разным планетам и познающем жизнь и человеческую природу.','1943','Éditions Gallimard','Антуан де Сент-Экзюпери',96,0,0,'d1d52882-3e5d-4e8b-8ea6-5e5d492e5e8e'),(19,'Гарри Поттер и Философский камень','Первый роман в серии о мальчике-волшебнике Гарри Поттере и его приключениях в школе магии Хогвартс.','1997','Bloomsbury','Роулинг Джоан Кэтлин',432,11,3,'4d4c7037-70c1-4228-880a-ae7eeddb6711'),(20,'Властелин колец','Эпическая трилогия о приключениях хоббита Фродо и его спутников в их попытке уничтожить Кольцо Всевластья.','1954','Allen and Unwin','Толкин Джон Рональд Руэл',1120,0,0,'2f66a77a-9bbf-4035-939c-2ae74dbd4a02'),(21,'Путешествия Гулливера','Сатирическое приключение, описывающее путешествия Гулливера в различные вымышленные страны.','1726','Benjamin Motte','Джонатан Свифт',351,0,0,'d48c2f49-f308-4b3a-800c-4df458d26299'),(22,'Моби Дик, или Белый Кит','Приключенческий роман о капитане Ахаве и его одержимости охотой на огромного белого кита.','1851','Harper and Brothers','Герман Мелвилл',960,0,0,'923d1519-b5ba-48a5-8951-1adc55314770'),(23,'Война и мир','Исторический роман, описывающий жизнь нескольких аристократических семей на фоне Наполеоновских войн.','1869','Русский вестник','Толстой Лев Николаевич',1225,0,0,'82d65966-502a-473b-90e1-bffe30358c36'),(24,'Гордость и предубеждение','Романтическая комедия о жизни семьи Беннет и любовных отношениях между Элизабет Беннет и мистером Дарси.','1813','T. Egerton, Whitehall','Джейн Остин',464,0,0,'e166e739-d045-4a2e-b0f7-56742544bb65'),(25,'Алиса в Стране чудес','Сказочная фантазия о девочке Алисе, которая попадает в волшебную страну и переживает необычные приключения.','1865','Macmillan','Льюис Кэрролл',143,0,0,'2c6ddfa5-1805-44eb-8115-12fffba148e1'),(26,'Хроники Нарнии','Фэнтези-серия о приключениях детей, попадающих в волшебную страну Нарнию и сражающихся против сил зла.','1956','Geoffrey Bles','Клайв Стейплз Льюис',912,0,0,'19d83f82-fb43-45fd-8050-120e9d930c40'),(27,'Старик и море. Острова и море','История старого рыбака Сантьяго, его борьбы с гигантской рыбой и размышлений о жизни.','1952','Charles Scribners Sons','Эрнест Хемингуэй',544,0,0,'7255d856-aa80-409a-9afb-e18d978f2d35'),(28,'Доктор Живаго','Историческая драма о судьбе врача и поэта Юрия Живаго на фоне событий Русской революции и Гражданской войны.','1957','Feltrinelli','Пастернак Борис Леонидович',592,0,0,'3148b4a0-a521-4e8b-b76b-a108c6f876c0'),(29,'Братья Карамазовы','Философский роман о жизни и судьбе трех братьев Карамазовых, затрагивающий вопросы морали, веры и человеческой природы.','1880','Русский вестник','Фёдор Достоевский',796,0,0,'b332139f-1548-48fe-8675-e6ee8f652d75'),(30,'О дивный новый мир','Антиутопический роман, описывающий будущее общество, где технологии и контроль правят жизнью людей.','1932','Chatto and Windus','Хаксли Олдос',192,0,0,'04450d93-8f86-404f-bed0-1ee0f623aa34');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_genres_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (3,'Антиутопия'),(5,'Детская литература'),(13,'Историческая драма'),(10,'Исторический роман'),(1,'Мистика'),(8,'Приключенческий роман'),(11,'Романтическая комедия'),(7,'Сатирическое приключение'),(12,'Сказочная фантазия'),(4,'Социальная драма'),(2,'Фантастика'),(9,'Философский роман'),(6,'Эпос');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `id` varchar(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `mimetype` varchar(100) NOT NULL,
  `hash_md5` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_images_hash_md5` (`hash_md5`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES ('04450d93-8f86-404f-bed0-1ee0f623aa34','cover14.png','image/png','403497b5c4cbffce343c68921d24128f'),('19d83f82-fb43-45fd-8050-120e9d930c40','cover10.png','image/png','ea80aa714ce0460fb82170cc086134e1'),('21900a41-4f78-41af-a145-08df161be96f','cover1.png','image/png','19b72dec5320872a2f0ad7364fee593b'),('2c6ddfa5-1805-44eb-8115-12fffba148e1','cover9.png','image/png','d24d9b964262ecc673c00f60aab5c72f'),('2f66a77a-9bbf-4035-939c-2ae74dbd4a02','cover4.png','image/png','e37de2eadaefbdfff14bf55758b6245d'),('3148b4a0-a521-4e8b-b76b-a108c6f876c0','cover12.png','image/png','653e4518c44c796339f31e1a2be51f25'),('4d4c7037-70c1-4228-880a-ae7eeddb6711','cover3.png','image/png','e99844e8ac4d26d3dfab5b48d3111a2a'),('7255d856-aa80-409a-9afb-e18d978f2d35','cover11.png','image/png','a4974655e243c5c38e37610917c0abc7'),('82d65966-502a-473b-90e1-bffe30358c36','cover7.png','image/png','00ffe0b3552a19f49bf0d5bb804a8c4c'),('923d1519-b5ba-48a5-8951-1adc55314770','cover6.png','image/png','f654eba970fcaafbaa1ffbf83f98e87a'),('9f8978e3-72db-442a-bb5a-c1d9899bfa61','cover.png','image/png','b4bdc74a25ee8a7b071c90f4a26614ce'),('b332139f-1548-48fe-8675-e6ee8f652d75','cover13.png','image/png','d2ac3b3333e1d882862d2b6852685cf7'),('d1d52882-3e5d-4e8b-8ea6-5e5d492e5e8e','cover2.png','image/png','2d67bdf2b952d25d59bd708b660bb056'),('d48c2f49-f308-4b3a-800c-4df458d26299','cover5.png','image/png','5aa7300f41b924557cc4ba17e072d32c'),('e166e739-d045-4a2e-b0f7-56742544bb65','cover8.png','image/png','5469b7cc0436ac675384b5cb4767f0a2');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mark` int NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `book_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reviews_book_id_books` (`book_id`),
  KEY `fk_reviews_user_id_users` (`user_id`),
  CONSTRAINT `fk_reviews_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_reviews_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (21,5,'&lt;script&gt;alert(\'XSS\');&lt;/script&gt;','2024-06-09 00:16:27',19,1),(22,5,'Замечательная книга!','2024-06-09 00:20:51',19,6),(23,1,'Плохая книга!','2024-06-09 00:25:40',19,4),(24,5,'Лучшая книга!','2024-06-09 16:03:08',16,1);
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Администратор','Полный доступ к системе, в том числе к созданию и удалению книг'),(2,'Модератор','Редактирование данных книг'),(3,'Пользователь','Создание рецензий');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `last_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) NOT NULL,
  `login` varchar(100) NOT NULL,
  `password_hash` varchar(256) NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login` (`login`),
  KEY `fk_users_role_id_roles` (`role_id`),
  CONSTRAINT `fk_users_role_id_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Максим','Дейникин','Юрьевич','admin','scrypt:32768:8:1$6Fnom3rqc7GFr7ou$9e904b79264116aa53425f8124141cb4c25bcba5eb81409cc87204a6086ab13b4fc98dc9b3a1f459824dd55643a5fa8adf2ce7c2bf22933db3e3d906a8323d36',1),(4,'Иван','Иванов','Иванович','moderator','scrypt:32768:8:1$tOOxepLDDJ07jaiD$a3248458b92f15b407a1ed843957d504cc834959b45da543845aa4c5b9b6ce06792e2cfa13c54e178df0f646d29ac4ad477ed79ecaa2824f441445f5d2fa7037',2),(6,'Инна','Иванова','Ивановна','user','scrypt:32768:8:1$4b4y9HrVufqvU1Ve$94e67d39226d01fa3014a8a5b84369d55697596557aae633e20451a2f06810d37e18624b1a66a00409c448e572e837d26c3ed8b8ec93806387a35069467d9dfc',3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-09 17:34:21
