require "crypto/bcrypt/password"
require "../../decorators/user"
require "../../authentication/jwt/tokenizer"

module Actions::Users
  struct Create < Prism::Action
    include Params

    params do
      param :user do
        param :email, String, validate: {regex: /@/}
        param :password, String, validate: {size: (1..64)}
        param :username, String, validate: {size: (1..32)}
        param :bio, String?
        param :image, String?, validate: {size: (1..255)}
      end
    end

    def call
      existing_user = repo.query_one?(User.where(email: params[:user][:email]).or(username: params[:user][:username]))
      halt!(422, "User already exists") if existing_user

      encrypted_password = Crypto::Bcrypt::Password.create(params[:user][:password])

      user = User.new(
        email: params[:user][:email],
        username: params[:user][:username],
        encrypted_password: encrypted_password.to_s,
      )

      halt!(422, "Invalid user: #{user.errors}") unless user.valid?
      user = repo.insert(user)

      token = Authentication::JWT::Tokenizer.new(user).tokenize

      json(201, {
        user: Decorators::User.new(user, token: token),
      })
    end
  end
end
