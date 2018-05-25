require "./user"
require "./article"

class Comment
  include Core::Schema
  include Core::Validation
  include Core::Query

  schema :comments do
    primary_key :id

    reference :author, User, key: :author_id
    reference :article, Article, key: :article_id

    field :body, String

    field :created_at, Time, db_default: true
    field :updated_at, Time, db_default: true
  end
end
