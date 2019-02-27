class Comment
  include Onyx::SQL::Model

  schema comments do
    pkey id : Int32, key: "rowid", converter: SQLite3::Any(Int32)
    type author : User, key: "author_id", not_null: true
    type article : Article, key: "article_id", not_null: true
    type body : String, not_null: true
    type created_at : Time, default: true, not_null: true
    type updated_at : Time, default: true
  end
end
