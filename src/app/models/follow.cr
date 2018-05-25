require "./user"

class Follow
  include Core::Schema
  include Core::Validation
  include Core::Query

  schema :follows do
    primary_key :id

    reference :follower, User, key: :follower_id
    reference :followee, User, key: :followee_id

    field :created_at, Time, db_default: true
  end
end
