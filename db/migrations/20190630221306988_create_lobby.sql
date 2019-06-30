-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE lobbies (
  id BIGSERIAL PRIMARY KEY,
  restricted BOOLEAN,
  theme_id INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX lobby_theme_id_idx ON lobbies (theme_id);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS lobbies;
