-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE lobbies (
  id BIGSERIAL PRIMARY KEY,
  restricted BOOLEAN,
  active BOOLEAN,
  theme_id INTEGER,
  created_by INTEGER,
  questions INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX lobby_theme_id_idx ON lobbies (theme_id);
CREATE INDEX lobby_created_by_idx ON lobbies (created_by);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS lobbies;
