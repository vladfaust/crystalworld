require "../../decorators/profile"

module Actions::Profiles
  struct Get < Prism::Action
    include Auth
    include Params

    params do
      param :username, String
    end

    def call
      profile = repo.query(User.where(username: params[:username])).first?
      halt!(404, "Profile not found") unless profile

      following = false
      if auth?
        following = repo.query(Follow
          .where(followee: profile, follower: auth.user)
        ).any?
      end

      json({
        profile: Decorators::Profile.new(profile, following: following),
      })
    end
  end
end
