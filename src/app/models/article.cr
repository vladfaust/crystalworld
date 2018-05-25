require "./user"
require "./comment"
require "./favorite"

class Article
  include Core::Schema
  include Core::Validation
  include Core::Query

  schema :articles do
    primary_key :id

    reference :author, User, key: :author_id
    reference :comments, Array(Comment), foreign_key: :article_id
    reference :favorites, Array(Favorite), foreign_key: :article_id

    field :slug, String, validate: {size: (1..64)}
    field :title, String
    field :description, String?
    field :body, String
    field :tags, Array(String)?

    field :agg_favorites_count, Int32, db_default: true

    field :created_at, Time, db_default: true
    field :updated_at, Time, db_default: true
  end
end
