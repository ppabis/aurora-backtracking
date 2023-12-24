ALTER TABLE players ADD COLUMN sum_score INT DEFAULT 0;
CREATE TABLE login_history(id INT PRIMARY KEY AUTO_INCREMENT, player_id INT, login_time DATETIME);
INSERT INTO login_history(player_id, login_time) VALUES (1, NOW() - INTERVAL 1 HOUR), (2, NOW() - INTERVAL 2 HOUR), (3, NOW() - INTERVAL 3 HOUR);
INSERT INTO players(username, sum_score) VALUES ("George", 100), ("Helen", 200), ("Ivan", 300);