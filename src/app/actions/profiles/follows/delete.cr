require "../../../decorators/profile"

module Actions::Profiles::Follows
  struct Delete < Prism::Action
    include Auth
    include Params

    auth!

    params do
      param :username, String
    end

    def call
      profile = repo.query(User
        .select(:id, :username, :bio, :image)
        .where(username: params[:username])
      ).first?
      halt!(404, "Profile not found") unless profile

      follow = repo.query(Follow
        .select(:id)
        .where(followee: profile, follower: auth.user)
      ).first?
      halt!(404, "Not following") unless follow

      repo.delete(follow)

      json(202, {
        profile: Decorators::Profile.new(profile, following: false),
      })
    end
  end
end
