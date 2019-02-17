module Views
  struct Profile
    include Onyx::REST::View

    def initialize(@profile : ::User, *, @following : Bool = false)
    end

    json({
      profile: {
        username:  @profile.username,
        bio:       @profile.bio?.to_s,
        image:     @profile.image?.to_s,
        following: @following,
      },
    })
  end
end
