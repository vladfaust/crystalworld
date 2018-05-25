require "./article"
require "./comment"
require "./favorite"
require "./follow"

class User
  include Core::Schema
  include Core::Validation
  include Core::Query

  schema :users do
    primary_key :id

    reference :articles, Array(Article), foreign_key: :author_id
    reference :comments, Array(Comment), foreign_key: :author_id
    reference :favorites, Array(Favorite), foreign_key: :user_id
    reference :following, Array(Follow), foreign_key: :follower_id
    reference :followers, Array(Follow), foreign_key: :followee_id

    field :email, String, validate: {regex: /@/}
    field :encrypted_password, String, key: :password
    field :username, String, validate: {size: (1..32)}
    field :bio, String?
    field :image, String?

    field :created_at, Time, db_default: true
    field :updated_at, Time, db_default: true
  end
end
