-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE users
  ADD status VARCHAR DEFAULT 'online',
  ADD rank VARCHAR DEFAULT 'user';

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE users
  DROP COLUMN status,
  DROP COLUMN rank;
