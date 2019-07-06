-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE friendships (
  id BIGSERIAL PRIMARY KEY,
  status VARCHAR DEFAULT 'pending',
  asked_by INTEGER,
  asked_to INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX friendships_asked_by_idx ON friendships (asked_by);
CREATE INDEX friendships_asked_to_idx ON friendships (asked_to);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS friendships;
