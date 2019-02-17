class Follow
  include Onyx::SQL::Model

  schema follows do
    pkey id : Int32, key: "rowid", converter: Onyx::SQL::Converters::SQLite3::Any(Int32)
    type follower : User, key: "follower_id"
    type followee : User, key: "followee_id"
    type created_at : Time, default: true
  end
end
