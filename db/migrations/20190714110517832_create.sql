-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE scores (
  id BIGSERIAL PRIMARY KEY,
  points INTEGER,
  question_id INTEGER,
  game_id INTEGER,
  user_id INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX score_user_id_idx ON scores (user_id);
CREATE INDEX score_game_id_idx ON scores (game_id);
CREATE INDEX score_question_id_idx ON scores (question_id);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS scores;
