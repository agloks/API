-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  password VARCHAR,
  email VARCHAR UNIQUE,
  nickname VARCHAR UNIQUE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS users;
