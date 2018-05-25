-- +migrate up
CREATE TABLE articles (
  id        SERIAL  PRIMARY KEY,

  -- References
  author_id INT REFERENCES users (id),

  -- Fields
  slug        VARCHAR(64) NOT NULL,
  title       TEXT        NOT NULL,
  description TEXT,
  body        TEXT        NOT NULL,
  tags        TEXT[],

  -- Aggregates
  agg_favorites_count INT NOT NULL DEFAULT 0,

  -- Timestamps
  created_at  TIMESTAMPTZ NOT NULL  DEFAULT NOW(),
  updated_at  TIMESTAMPTZ           DEFAULT NOW()
);

-- Indexes
CREATE INDEX articles_author_id_index ON articles (author_id);
CREATE UNIQUE INDEX articles_slug_index ON articles (slug);
CREATE INDEX articles_tags_index ON articles (tags);
CREATE INDEX articles_created_at_index ON articles (created_at);

-- +migrate down
DROP TABLE articles;
