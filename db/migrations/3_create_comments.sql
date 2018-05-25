-- +migrate up
CREATE TABLE comments (
  id        SERIAL  PRIMARY KEY,

  -- References
  author_id   INT REFERENCES users (id),
  article_id  INT REFERENCES articles (id)  ON DELETE CASCADE,

  -- Fields
  body  TEXT  NOT NULL,

  -- Timestamps
  created_at  TIMESTAMPTZ NOT NULL  DEFAULT NOW(),
  updated_at  TIMESTAMPTZ           DEFAULT NOW()
);

-- Indexes
CREATE INDEX comments_article_id_index ON comments (article_id);
CREATE INDEX comments_created_at_index ON comments (created_at);

-- +migrate down
DROP TABLE comments;
