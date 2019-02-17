require "crypto/bcrypt/password"

module Actions::Users
  struct Create
    include Onyx::REST::Action
    include Auth

    params do
      json do
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
      type JSONRequestExpected(400)
      type UserAlreadyExists(422)
    end

    def call
      raise JSONRequestExpected.new unless json = params.json

      existing_user = Onyx.query(User
        .select(:id)
        .where(email: json.user.email)
        .or(username: json.user.username)
      ).first?
      raise UserAlreadyExists.new if existing_user

      encrypted_password = Crypto::Bcrypt::Password.create(json.user.password)

      user = User.new(
        email: json.user.email,
        username: json.user.username,
        encrypted_password: encrypted_password.to_s,
      )

      cursor = Onyx.exec(user.insert)
      user.id = cursor.last_insert_id.to_i

      token = jwtize(user)

      status(201)
      view(Views::User.new(user, token: token))
    end
  end
end
