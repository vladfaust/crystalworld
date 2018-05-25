-- +migrate up
CREATE TABLE favorites (
  id          SERIAL  PRIMARY KEY,

  -- References
  article_id  INT REFERENCES articles (id)  ON DELETE CASCADE,
  user_id     INT REFERENCES users (id),

  -- Timestamps
  created_at  TIMESTAMPTZ NOT NULL  DEFAULT NOW()
);

-- Indexes
CREATE INDEX favorites_article_id_index ON favorites (article_id);
CREATE INDEX favorites_user_id_index ON favorites (user_id);
CREATE UNIQUE INDEX favorites_relation_index ON favorites (article_id, user_id);
CREATE INDEX favorites_created_at_index ON favorites (created_at);

-- +migrate down
DROP TABLE favorites;
