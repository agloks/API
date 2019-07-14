-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE games (
  id BIGSERIAL PRIMARY KEY,
  running BOOLEAN,
  lobby_id INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS games;
