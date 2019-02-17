class Tag
  include Onyx::SQL::Model

  schema tags do
    pkey id : Int32, key: "rowid", converter: Onyx::SQL::Converters::SQLite3::Any(Int32)
    type content : String
    type articles : Array(Article), foreign_key: "tag_ids"
  end
end
