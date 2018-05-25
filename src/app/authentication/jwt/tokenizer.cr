require "./settings"

module Authentication::JWT
  class Tokenizer
    include Settings

    EXPIRATION = 1.month

    def initialize(@user : User)
    end

    def tokenize
      payload = {
        "iss"  => issuer,
        "sub"  => subject,
        "exp"  => (Time.now + EXPIRATION).epoch,
        "user" => {
          "id" => @user.id,
        },
      }

      ::JWT.encode(payload, ENV["JWT_SECRET_KEY"], algorithm)
    end
  end
end
