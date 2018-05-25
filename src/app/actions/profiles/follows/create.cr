require "../../../decorators/profile"

module Actions::Profiles::Follows
  struct Create < Prism::Action
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

      follow = Follow.new(followee: profile, follower: auth.user)

      begin
        repo.insert(follow.valid!)
      rescue ex : PQ::PQError
        case ex.message
        when /duplicate key/ then halt!(422, "Already following")
        else
          raise ex
        end
      end

      json({
        profile: Decorators::Profile.new(profile, following: true),
      })
    end
  end
end
