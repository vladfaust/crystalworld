-- +migrate up
CREATE TABLE tags (
  -- Fields
  content TEXT  NOT NULL,

  -- Timestamps
  created_at  TEXT  NOT NULL  DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now'))
);

-- Indexes
CREATE  UNIQUE INDEX  tags_content_index  ON  tags(content);

-- +migrate down
DROP TABLE tags;
