module Actions::Articles::Favorites
  struct Delete
    include Onyx::REST::Action
    include Auth
    include Articles

    auth!

    params do
      path do
        type slug : String
      end
    end

    errors do
      type ArticleNotFound(404)
      type NotFavoritedYet(422)
    end

    def call
      article = Onyx.query(Article
        .select(Article, :id)
        .where(slug: params.path.slug)
        .join(author: true) do |q|
          q.select(:username)
        end
      ).first?
      raise ArticleNotFound.new unless article

      deleted = Onyx.exec(Favorite.delete.where(
        user: auth.user,
        article: article,
      )).try &.rows_affected
      raise NotFavoritedYet.new unless deleted > 0

      changeset = article.changeset
      changeset.update(agg_favorites_count: article.agg_favorites_count - 1)
      article.apply(changeset)

      # TODO: Make it async
      Onyx.exec(article.update(changeset))
      preload_articles_tags({article})

      status(202)
      view(Views::Article.new(article, favorited: false))
    end
  end
end
