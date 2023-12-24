CREATE DATABASE testdb;
USE testdb;
CREATE TABLE players(id INT PRIMARY KEY AUTO_INCREMENT, username VARCHAR(30));
INSERT INTO players(username) VALUES ("Alice"), ("Bob"), ("Charlie");