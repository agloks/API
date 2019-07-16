-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE games_users (
  id BIGSERIAL PRIMARY KEY,
  game_id INTEGER,
  user_id INTEGER,
  points INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX game_user_user_id_idx ON games_users (user_id);
CREATE INDEX game_user_game_id_idx ON games_users (game_id);


-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS games_users;
