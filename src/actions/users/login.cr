require "crypto/bcrypt/password"

module Actions::Users
  struct Login
    include Onyx::REST::Action
    include Auth

    params do
      json require: true do
        type user do
          type email : String
          type password : String
        end
      end
    end

    errors do
      type EmailTaken(422)
      type UserNotFound(404)
      type InvalidCredentials(401)
    end

    def call
      user = Onyx.query(User.where(email: params.json.user.email).select(User, :id)).first?
      raise UserNotFound.new unless user

      encrypted_password = Crypto::Bcrypt::Password.new(user.encrypted_password)
      raise InvalidCredentials.new unless encrypted_password == params.json.user.password

      view(Views::User.new(user, token: jwtize(user)))
    end
  end
end
