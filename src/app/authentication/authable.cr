require "jwt"
require "./jwt/settings"
require "../../models/user"

module Authentication
  class Authable < Prism::Authable
    include JWT::Settings

    @user : User? = nil
    getter! user
    getter token : String

    def initialize(@token)
    end

    def auth : User?
      return @user if @user

      payload, header = ::JWT.decode(
        @token,
        ENV["JWT_SECRET_KEY"],
        algorithm,
        iss: issuer,
        sub: subject,
      )

      id = uninitialized Int64

      begin
        # JWT is expected to contain "{user: {id: 42}}"
        id = payload["user"].as(Hash)["id"].as(Int)
      rescue ex : JSON::Error
        logger.debug("Mailformed JWT: #{ex}")
        return nil
      end

      @user = User.new(id: id)
    rescue ex : ::JWT::Error
      logger.debug("Authentication failure: #{ex}")
      return nil
    end
  end
end
