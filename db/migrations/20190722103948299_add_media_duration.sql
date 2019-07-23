-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE lobbies ADD media_duration INTEGER;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE lobbies DROP COLUMN media_duration;
