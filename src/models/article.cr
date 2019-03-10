class Article
  include Onyx::SQL::Model

  schema articles do
    pkey id : Int32, key: "rowid", converter: SQLite3::Any(Int32)

    type author : User, key: "author_id", not_null: true

    type slug : String, not_null: true
    type title : String, not_null: true
    type description : String
    type body : String, not_null: true

    type agg_favorites_count : Int32, not_null: true, default: true

    type created_at : Time, not_null: true, default: true
    type updated_at : Time, default: true

    type tags : Array(Tag), key: "tag_ids", not_null: true
    type comments : Array(Comment), foreign_key: "article_id"
    type favorites : Array(Favorite), foreign_key: "article_id"
  end
end
