require "./user"
require "./article"

class Favorite
  include Core::Schema
  include Core::Validation
  include Core::Query

  schema :favorites do
    primary_key :id

    reference :article, Article, key: :article_id
    reference :user, User, key: :user_id

    field :created_at, Time, db_default: true
  end
end
