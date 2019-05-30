-- +micrate Up
CREATE TABLE medias (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR,
  kind VARCHAR,
  theme_id INTEGER NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX media_theme_id_idx ON medias (theme_id); 


-- +micrate Down
DROP TABLE IF EXISTS medias;
