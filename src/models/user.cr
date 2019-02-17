class User
  include Onyx::SQL::Model

  schema users do
    pkey id : Int32, key: "rowid", converter: Onyx::SQL::Converters::SQLite3::Any(Int32)

    type email : String
    type encrypted_password : String, key: "password"
    type username : String
    type bio : String
    type image : String

    type created_at : Time, default: true
    type updated_at : Time, default: true

    type articles : Array(Article), foreign_key: "author_id"
    type comments : Array(Comment), foreign_key: "author_id"
    type favorites : Array(Favorite), foreign_key: "user_id"
    type following : Array(Follow), foreign_key: "follower_id"
    type followers : Array(Follow), foreign_key: "followee_id"
  end
end
