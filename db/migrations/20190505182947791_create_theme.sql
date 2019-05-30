-- +micrate Up
CREATE TABLE themes (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR,
  description VARCHAR,
  user_id INTEGER NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX theme_user_id_idx ON themes (user_id); 


-- +micrate Down
DROP TABLE IF EXISTS themes;
