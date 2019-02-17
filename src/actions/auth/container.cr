require "jwt"
require "json"
require "./settings"

module Actions::Auth
  struct Container
    getter! user : User
    getter! token : String

    def authed?
      !!@user
    end

    def initialize(@token : String)
      payload, header = JWT.decode(
        token,
        Settings.secret,
        Settings.algorithm,
        iss: Settings.issuer,
        sub: Settings.subject,
      )

      # JWT is expected to contain "{user: {id: 42}}"
      id = payload["user"].as_h["id"].as_i
      @user = User.new(id: id)
    rescue ex : JSON::Error | TypeCastError
      Onyx.logger.debug("Malformed JWT: #{ex}")
    rescue ex : JWT::Error
      Onyx.logger.debug("Authentication failure: #{ex}")
      return nil
    end
  end
end
