module Decorators
  struct User
    def initialize(@user : ::User, *, @token : String? = nil)
    end

    def to_json(builder)
      builder.object do
        builder.field("email", @user.email.to_s)
        builder.field("username", @user.username.to_s)
        builder.field("bio", @user.bio.to_s)
        builder.field("image", @user.image.to_s)
        builder.field("token", @token) if @token
      end
    end
  end
end
