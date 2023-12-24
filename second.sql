USE testdb;
INSERT INTO players(username) VALUES ("Dave"), ("Eve"), ("Frank");
CREATE TABLE games(id INT PRIMARY KEY AUTO_INCREMENT, player1 INT, player2 INT, score INT);
INSERT INTO games(player1, player2, score) VALUES (1, 2, 10), (1, 3, 20), (2, 3, 30);