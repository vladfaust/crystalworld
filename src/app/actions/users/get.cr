module Actions::Users
  struct Get < Prism::Action
    include Auth

    auth! # Require authentication, halt with 401 otherwise

    def call
      user = repo.query(User.where(id: auth.user.id)).first

      json({
        user: Decorators::User.new(user, token: auth.token),
      })
    end
  end
end
