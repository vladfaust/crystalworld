require "crypto/bcrypt/password"

module Actions::Users
  struct Login
    include Onyx::REST::Action
    include Auth

    params do
      json do
        type user do
          type email : String
          type password : String
        end
      end
    end

    errors do
      type JSONRequestExpected(400)
      type EmailTaken(422)
      type UserNotFound(404)
      type InvalidCredentials(401)
    end

    def call
      raise JSONRequestExpected.new unless json = params.json
      user = Onyx.query(User.where(email: json.user.email).select(User, :id)).first?
      raise UserNotFound.new unless user

      encrypted_password = Crypto::Bcrypt::Password.new(user.encrypted_password)
      raise InvalidCredentials.new unless encrypted_password == json.user.password

      view(Views::User.new(user, token: jwtize(user)))
    end
  end
end
