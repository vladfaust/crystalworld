class Favorite
  include Onyx::SQL::Model

  schema favorites do
    pkey id : Int32, key: "rowid", converter: Onyx::SQL::Converters::SQLite3::Any(Int32)
    type article : Article, key: "article_id"
    type user : User, key: "user_id"
    type created_at : Time, default: true
  end
end
