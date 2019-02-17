module Actions::Profiles::Follows
  struct Delete
    include Onyx::REST::Action
    include Auth

    auth!

    params do
      path do
        type username : String
      end
    end

    errors do
      type ProfileNotFound(404)
      type NotFollowing(404)
    end

    def call
      profile = Onyx.query(User
        .select(:id, :username, :bio, :image)
        .where(username: params.path.username)
      ).first?
      raise ProfileNotFound.new unless profile

      follow = Onyx.query(Follow
        .select(:id)
        .where(followee: profile, follower: auth.user)
      ).first?
      raise NotFollowing.new unless follow

      Onyx.exec(follow.delete)

      status(200)
      view(Views::Profile.new(profile, following: false))
    end
  end
end
