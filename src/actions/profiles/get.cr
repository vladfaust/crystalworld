module Actions::Profiles
  struct Get
    include Onyx::REST::Action
    include Auth

    params do
      path do
        type username : String
      end
    end

    errors do
      type ProfileNotFound(404)
    end

    def call
      profile = Onyx.query(User.where(username: params.path.username).select(User, :id)).first?
      raise ProfileNotFound.new unless profile

      following = false
      if auth.user?
        following = Onyx.query(Follow
          .where(followee: profile, follower: auth.user)
          .select(:id)
        ).any?
      end

      view(Views::Profile.new(profile, following: following))
    end
  end
end
