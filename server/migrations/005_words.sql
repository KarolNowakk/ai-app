-- +goose Up
CREATE TABLE IF NOT EXISTS words (
       id INT AUTO_INCREMENT PRIMARY KEY,
       word VARCHAR(255) NOT NULL,
       user_id BIGINT NOT NULL,
       last_review VARCHAR(255) NOT NULL,
       `interval` INT NOT NULL,
       ease_factor REAL NOT NULL,
       repetition INT NOT NULL
);

-- +goose Down
DROP TABLE IF EXISTS words;