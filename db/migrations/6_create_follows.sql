-- +migrate up
CREATE TABLE follows (
  -- References
  follower_id INT REFERENCES users(rowid),
  followee_id INT REFERENCES users(rowid),

  -- Timestamps
  created_at  TEXT  NOT NULL  DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now'))
);

-- Indexes
CREATE INDEX follows_follower_id_index      ON follows(follower_id);
CREATE INDEX follows_followee_id_index      ON follows(followee_id);
CREATE UNIQUE INDEX follows_relation_index  ON follows(follower_id, followee_id);
CREATE INDEX follows_created_at_index       ON follows(created_at);

-- +migrate down
DROP TABLE follows;
