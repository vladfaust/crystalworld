class Follow
  include Onyx::SQL::Model

  schema follows do
    pkey id : Int32, key: "rowid", converter: SQLite3::Any(Int32)
    type follower : User, key: "follower_id", not_null: true
    type followee : User, key: "followee_id", not_null: true
    type created_at : Time, default: true, not_null: true
  end
end
