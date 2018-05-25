module Actions::Articles
  struct Update < Prism::Action
    include Params
    include Auth

    auth!

    params do
      param :slug, String
      param :article do
        param :description, String?
        param :body, String?
        param :tags, Array(String)?
      end
    end

    def call
      halt!(400, "At least one attribute to update required") if params[:article].empty?

      article = repo.query(Article.where(slug: params[:slug]).join(:author, select: [:username])).first?

      halt!(404, "Article not found") unless article
      halt!(403) unless article.author_id == auth.user.id

      {% for field in %w(description body tags) %}
        article.{{field.id}} = params[:article][{{field}}] if params[:article][{{field}}]
      {% end %}

      halt!(422, "No changes") if article.changes.empty?

      article.updated_at = Time.now

      if article.valid?
        repo.update(article)

        favorited = false
        favorited = repo.query(Favorite
          .where(article: article, user: auth.user)
        ).any? if auth?

        json(204, {
          article: Decorators::Article.new(article, favorited: favorited),
        })
      else
        halt!(400, "Invalid article: #{article.errors}")
      end
    end
  end
end
