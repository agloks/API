-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE users ADD lobby_id INTEGER;
CREATE INDEX user_lobby_id_idx ON users (lobby_id);

ALTER TABLE lobbies ADD private_key VARCHAR;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE users DROP COLUMN lobby_id;
ALTER TABLE lobbies DROP COLUMN private_key;
