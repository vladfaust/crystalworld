module Authentication::JWT
  module Settings
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
end
