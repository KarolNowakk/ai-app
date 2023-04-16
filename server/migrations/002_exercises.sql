-- +goose Up
CREATE TABLE IF NOT EXISTS exercises (
   id INT AUTO_INCREMENT PRIMARY KEY,
   userID VARCHAR(255),
   text TEXT NOT NULL,
   use_srs BOOLEAN NOT NULL,
   title VARCHAR(255) NOT NULL,
   messages TEXT NOT NULL
)
    ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- +goose Down
DROP TABLE IF EXISTS exercises;