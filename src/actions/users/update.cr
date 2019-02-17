module Actions::Users
  struct Update
    include Onyx::REST::Action
    include Auth

    auth!

    params do
      json do
        type user do
          type email : String?
          type bio : String?
          type image : String?
        end
      end
    end

    errors do
      type JSONRequestExpected(400)

      type NoParametersToUpdate(400) do
        super("At least one parameter to update is required")
      end

      # type NoChangesToUpdate(422)
      type EmailTaken(422)
    end

    def call
      raise JSONRequestExpected.new unless json = params.json

      if {{ %w(email bio image).map { |a| "json.user.#{a.id}.nil?" }.join(" && ").id }}
        raise NoParametersToUpdate.new
      end

      user = Onyx.query(User.where(id: auth.user.id).select(User, :id)).first
      changeset = user.changeset

      {% begin %}
        {% for field in %w(email bio image) %}
          if param = json.user.{{field.id}}
            changeset.update({{field.id}}: param)
          end
        {% end %}
      {% end %}

      # raise NoChangesToUpdate.new if changeset.empty?
      return view(Views::User.new(user, token: auth.token)) if changeset.empty?

      changeset.update(updated_at: Time.now)

      begin
        Onyx.exec(user.update(changeset))

        status(204)
        view(Views::User.new(user, token: auth.token))
      rescue ex : SQLite3::Exception
        if ex.message =~ /UNIQUE constraint failed: users.email/
          raise EmailTaken.new
        else
          raise ex
        end
      end
    end
  end
end
