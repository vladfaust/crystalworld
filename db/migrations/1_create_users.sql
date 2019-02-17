-- +migrate up
CREATE TABLE users (
  -- Fields
  email     TEXT  NOT NULL,
  password  TEXT  NOT NULL, -- It's stored encrypted
  username  TEXT  NOT NULL,
  bio       TEXT,
  image     VARCHAR(256),

  -- Timestamps
  created_at  TEXT  NOT NULL  DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now')),
  updated_at  TEXT            DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'now'))
);

-- Indexes
CREATE UNIQUE INDEX users_email_index     ON users(email);
CREATE UNIQUE INDEX users_username_index  ON users(username);

-- +migrate down
DROP TABLE users;
