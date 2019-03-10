class Favorite
  include Onyx::SQL::Model

  schema favorites do
    pkey id : Int32, key: "rowid", converter: SQLite3::Any(Int32)
    type article : Article, key: "article_id", not_null: true
    type user : User, key: "user_id", not_null: true
    type created_at : Time, not_null: true, default: true
  end
end
