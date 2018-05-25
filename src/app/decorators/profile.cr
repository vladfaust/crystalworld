module Decorators
  struct Profile
    def initialize(@profile : ::User, *, @following : Bool = false)
    end

    def to_json(builder)
      builder.object do
        builder.field("username", @profile.username.to_s)
        builder.field("bio", @profile.bio.to_s)
        builder.field("image", @profile.image.to_s)
        builder.field("following", @following)
      end
    end
  end
end
