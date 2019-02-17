require "./auth/*"

module Actions::Auth
  protected getter! auth : Container

  macro included
    errors do
      type Unauthorized(401)
      type Forbidden(403)
    end

    before do
      if token = context.request.headers["Authorization"]?.try &.[/Token ([\w.\.-]+)/, 1]?
        @auth = Container.new(token)
      end
    end
  end

  macro auth!
    before do
      unless auth? && auth.authed?
        puts "Not authed"
        raise Unauthorized.new
      end
    end
  end

  def jwtize(user : User)
    payload = {
      "iss"  => Settings.issuer,
      "sub"  => Settings.subject,
      "exp"  => (Time.now + Settings.expiration).to_unix,
      "user" => {
        "id" => user.id,
      },
    }

    JWT.encode(payload, Settings.secret, Settings.algorithm)
  end
end
