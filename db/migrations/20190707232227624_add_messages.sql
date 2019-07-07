-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE messages (
  id BIGSERIAL PRIMARY KEY,
  lobby_id INTEGER,
  user_id INTEGER,
  content TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX message_lobby_id_idx ON messages (lobby_id);
CREATE INDEX message_user_id_idx ON messages (user_id);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS messages;
