class Tag
  include Onyx::SQL::Model

  schema tags do
    pkey id : Int32, key: "rowid", converter: SQLite3::Any(Int32)
    type content : String, not_null: true
    type articles : Array(Article), foreign_key: "tag_ids"
  end
end
