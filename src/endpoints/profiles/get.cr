module Endpoints::Profiles
  struct Get
    include Onyx::HTTP::Endpoint
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
      profile = Onyx::SQL.query(User.where(username: params.path.username).select(User, :id)).first?
      raise ProfileNotFound.new unless profile

      following = false
      if auth.user?
        following = Onyx::SQL.query(Follow
          .where(followee: profile, follower: auth.user)
          .select(:id)
        ).any?
      end

      view(Views::Profile.new(profile, following: following))
    end
  end
end
