runtime_env JWT_SECRET_KEY

module Actions::Auth::Settings
  extend self

  def expiration
    1.month
  end

  def secret
    ENV["JWT_SECRET_KEY"]
  end

  def algorithm
    "HS256"
  end

  def audience
  end

  def issuer
    "crystalworld"
  end

  def subject
    "auth"
  end
end
