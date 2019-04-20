require "crypto/bcrypt/password"

module Endpoints::Users
  struct Create
    include Onyx::HTTP::Endpoint
    include Auth

    params do
      json require: true do
        type user do
          type email : String
          type password : String
          type username : String
          type bio : String?
          type image : String?
        end
      end
    end

    errors do
      type UserAlreadyExists(422)
    end

    def call
      existing_user = Onyx::SQL.query(User
        .select(:id)
        .where(email: params.json.user.email)
        .or(username: params.json.user.username)
      ).first?
      raise UserAlreadyExists.new if existing_user

      encrypted_password = Crypto::Bcrypt::Password.create(params.json.user.password)

      user = User.new(
        email: params.json.user.email,
        username: params.json.user.username,
        encrypted_password: encrypted_password.to_s,
      )

      cursor = Onyx::SQL.exec(user.insert)
      user.id = cursor.last_insert_id.to_i

      token = jwtize(user)

      status(201)
      view(Views::User.new(user, token: token))
    end
  end
end
