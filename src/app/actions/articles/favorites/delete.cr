require "../../../decorators/article"

module Actions::Articles::Favorites
  struct Delete < Prism::Action
    include Params
    include Auth

    auth!

    params do
      param :slug, String
    end

    def call
      article = repo.query(Article
        .where(slug: params[:slug])
        .join(:author, select: [:username])
      ).first?
      halt!(404, "Article not found") unless article

      deleted = repo.delete(Favorite
        .where(user: auth.user, article: article)
      ).try &.rows_affected
      halt!(404, "Not favorited yet") unless deleted > 0

      article.agg_favorites_count -= 1
      repo.update(article.valid!)

      json(202, {
        article: Decorators::Article.new(article, favorited: false),
      })
    end
  end
end
