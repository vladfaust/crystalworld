module Actions::Users
  struct Get
    include Onyx::REST::Action
    include Auth

    auth! # Require authentication, halt with 401 otherwise

    def call
      user = Onyx.query(User.where(id: auth.user.id).select(User, :id)).first
      view(Views::User.new(user, token: auth.token))
    end
  end
end
