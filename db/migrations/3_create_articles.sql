-- +migrate up
CREATE TABLE articles (
  -- References
  author_id INT   REFERENCES users(rowid),
  tag_ids   TEXT, -- In SQLite, there are no arrays

  -- Fields
  slug        VARCHAR(64) NOT NULL,
  title       TEXT        NOT NULL,
  description TEXT,
  body        TEXT        NOT NULL,

  -- Aggregates
  agg_favorites_count INT NOT NULL DEFAULT 0,

  -- Timestamps
  created_at  TEXT  NOT NULL  DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now')),
  updated_at  TEXT            DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now'))
);

-- Indexes
CREATE INDEX articles_author_id_index   ON articles(author_id);
CREATE UNIQUE INDEX articles_slug_index ON articles(slug);
CREATE INDEX articles_created_at_index  ON articles(created_at);

-- +migrate down
DROP TABLE articles;
