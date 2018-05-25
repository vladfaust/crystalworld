module Actions::Users
  struct Update < Prism::Action
    include Params
    include Auth

    auth!

    params do
      param :user do
        param :email, String?, validate: {regex: /@/}
        param :bio, String?
        param :image, String?, validate: {size: (1..255)}
      end
    end

    def call
      halt!(400, "At least one attribute to update required") if params[:user].empty?

      user = repo.query(User.where(id: auth.user.id)).first

      {% for field in %w(email bio image) %}
        user.{{field.id}} = params[:user][{{field}}] if params[:user][{{field}}]
      {% end %}
      halt!(422, "No changes") if user.changes.empty?

      user.updated_at = Time.now

      if user.valid?
        repo.update(user)

        json(204, {
          user: Decorators::User.new(user, token: auth.token),
        })
      else
        halt!(400, "Invalid user: #{user.errors}")
      end
    end
  end
end
