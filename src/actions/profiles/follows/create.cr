module Actions::Profiles::Follows
  struct Create
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
      type AlreadyFollowing(422)
    end

    def call
      profile = Onyx.query(User
        .select(:id, :username, :bio, :image)
        .where(username: params.path.username)
      ).first?
      raise ProfileNotFound.new unless profile

      begin
        Onyx.exec(Follow.insert(followee: profile, follower: auth.user))
      rescue ex : SQLite3::Exception
        case ex.message
        when /UNIQUE constraint failed/ then raise AlreadyFollowing.new
        else
          raise ex
        end
      end

      view(Views::Profile.new(profile, following: true))
    end
  end
end
