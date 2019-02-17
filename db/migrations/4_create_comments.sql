-- +migrate up
CREATE TABLE comments (
  -- References
  author_id   INT REFERENCES users(rowid),
  article_id  INT REFERENCES articles(rowid)  ON DELETE CASCADE,

  -- Fields
  body  TEXT  NOT NULL,

  -- Timestamps
  created_at  TEXT  NOT NULL  DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now')),
  updated_at  TEXT            DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now'))
);

-- Indexes
CREATE INDEX comments_article_id_index  ON comments(article_id);
CREATE INDEX comments_created_at_index  ON comments(created_at);

-- +migrate down
DROP TABLE comments;
