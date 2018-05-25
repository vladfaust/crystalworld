require "crypto/bcrypt/password"
require "../../decorators/user"
require "../../authentication/jwt/tokenizer"

module Actions::Users
  struct Login < Prism::Action
    include Params

    params do
      param :user do
        param :email, String, validate: {regex: /@/}
        param :password, String, validate: {size: (0..64)}
      end
    end

    def call
      user = repo.query_one?(User.where(email: params[:user][:email]))
      halt!(404, "User not found") unless user

      encrypted_password = Crypto::Bcrypt::Password.new(user.encrypted_password)
      halt!(401, "Wrong password") unless encrypted_password == params[:user][:password]

      token = Authentication::JWT::Tokenizer.new(user).tokenize

      json({
        user: Decorators::User.new(user, token: token),
      })
    end
  end
end
