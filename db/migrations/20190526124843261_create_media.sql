-- +micrate Up
CREATE TABLE medias (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR,
  kind VARCHAR,
  theme_id INTEGER NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
ALTER TABLE medias
ADD CONSTRAINT fk_theme_media FOREIGN KEY (theme_id) REFERENCES themes(id);


-- +micrate Down
DROP TABLE IF EXISTS medias;
