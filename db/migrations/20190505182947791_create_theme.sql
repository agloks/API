-- +micrate Up
CREATE TABLE themes (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR,
  description VARCHAR,
  user_id INTEGER NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
ALTER TABLE themes
ADD CONSTRAINT fk_user_theme FOREIGN KEY (user_id) REFERENCES users(id);


-- +micrate Down
DROP TABLE IF EXISTS themes;
