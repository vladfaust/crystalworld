class Article
  include Onyx::SQL::Model

  schema articles do
    pkey id : Int32, key: "rowid", converter: Onyx::SQL::Converters::SQLite3::Any(Int32)

    type author : User, key: "author_id"

    type slug : String
    type title : String
    type description : String
    type body : String

    type agg_favorites_count : Int32, default: true

    type created_at : Time, default: true
    type updated_at : Time, default: true

    type tags : Array(Tag), key: "tag_ids"
    type comments : Array(Comment), foreign_key: "article_id"
    type favorites : Array(Favorite), foreign_key: "article_id"
  end
end
