-- +migrate up
CREATE TABLE favorites (
  -- References
  article_id  INT REFERENCES articles(rowid)  ON DELETE CASCADE,
  user_id     INT REFERENCES users(rowid),

  -- Timestamps
  created_at  TEXT  NOT NULL  DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now'))
);

-- Indexes
CREATE INDEX favorites_article_id_index       ON favorites(article_id);
CREATE INDEX favorites_user_id_index          ON favorites(user_id);
CREATE UNIQUE INDEX favorites_relation_index  ON favorites(article_id, user_id);
CREATE INDEX favorites_created_at_index       ON favorites(created_at);

-- +migrate down
DROP TABLE favorites;
