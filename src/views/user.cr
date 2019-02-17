module Views
  struct User
    include Onyx::REST::View

    def initialize(@user : ::User, *, @token : String? = nil, @nested = false)
    end

    json do
      object do
        unless @nested
          string "user"
          start_object
        end

        field "email", @user.email?.to_s
        field "username", @user.username?.to_s
        field "bio", @user.bio?.to_s
        field "image", @user.image?.to_s

        if @token
          field "token", @token
        end

        unless @nested
          end_object
        end
      end
    end
  end
end
