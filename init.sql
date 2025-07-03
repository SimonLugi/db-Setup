DROP DATABASE IF EXISTS shapeshift;
CREATE DATABASE IF NOT EXISTS shapeshift;
USE shapeshift;

CREATE TABLE user (
                      id_user INT AUTO_INCREMENT PRIMARY KEY,
                      username VARCHAR(255) NOT NULL UNIQUE,
                      password VARCHAR(255) NOT NULL,
                      email VARCHAR(255) NOT NULL UNIQUE,
                      topscore INT DEFAULT 0,
                      beat_level1 BOOL DEFAULT FALSE,
                      beat_level2 BOOL DEFAULT FALSE,
                      beat_level3 BOOL DEFAULT FALSE
);

CREATE TABLE runs (
                      id_run INT AUTO_INCREMENT PRIMARY KEY,
                      user_id INT NOT NULL,
                      score INT NOT NULL,
                      level INT NOT NULL,
                      time TIMESTAMP NOT NULL,
                      FOREIGN KEY (user_id) REFERENCES user(id_user) ON DELETE CASCADE
);
