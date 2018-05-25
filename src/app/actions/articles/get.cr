require "../../decorators/article"

module Actions::Articles
  struct Get < Prism::Action
    include Params
    include Auth

    params do
      param :slug, String
    end

    def call
      article = repo.query(Article
        .where(slug: params[:slug])
        .join(:author, select: [:username])
      ).first?
      halt!(404, "Article not found") unless article

      favorited = false
      favorited = repo.query(Favorite
        .where(article: article, user: auth.user)
      ).any? if auth?

      json({
        article: Decorators::Article.new(article, favorited: favorited),
      })
    end
  end
end
