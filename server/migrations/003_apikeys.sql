-- +goose Up
CREATE TABLE IF NOT EXISTS api_keys (
      `key` VARCHAR(255) PRIMARY KEY,
      user_id BIGINT NOT NULL
);

-- +goose Down
DROP TABLE IF EXISTS api_keys;