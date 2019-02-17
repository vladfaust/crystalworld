class Comment
  include Onyx::SQL::Model

  schema comments do
    pkey id : Int32, key: "rowid", converter: Onyx::SQL::Converters::SQLite3::Any(Int32)
    type author : User, key: "author_id"
    type article : Article, key: "article_id"
    type body : String
    type created_at : Time, default: true
    type updated_at : Time, default: true
  end
end
