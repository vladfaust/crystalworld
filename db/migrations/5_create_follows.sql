-- +migrate up
CREATE TABLE follows (
  id          SERIAL  PRIMARY KEY,

  -- References
  follower_id INT REFERENCES users (id),
  followee_id INT REFERENCES users (id),

  -- Timestamps
  created_at  TIMESTAMPTZ NOT NULL  DEFAULT NOW()
);

-- Indexes
CREATE INDEX follows_follower_id_index ON follows (follower_id);
CREATE INDEX follows_followee_id_index ON follows (followee_id);
CREATE UNIQUE INDEX follows_relation_index ON follows (follower_id, followee_id);
CREATE INDEX follows_created_at_index ON follows (created_at);

-- +migrate down
DROP TABLE follows;
