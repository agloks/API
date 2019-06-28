-- +micrate Up
CREATE TABLE questions (
  id BIGSERIAL PRIMARY KEY,
  content VARCHAR,
  media_id INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX question_media_id_idx ON questions (media_id);

-- +micrate Down
DROP TABLE IF EXISTS questions;
