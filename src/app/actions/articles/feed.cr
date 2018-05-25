require "../../decorators/article"

module Actions::Articles
  struct Feed < Prism::Action
    include Auth

    auth!

    def call
      articles = repo.query(Article
        .join(:author, select: [:username])
        .join(:follows, on: {:followee_id, "author.id"})
        .where("followee_id = ?", {auth.user.id})
      )

      favorites = {} of Core::PrimaryKey => Bool

      if articles.size > 0
        repo.query(Favorite
          .where(user: auth.user, article: articles)
        ).each do |favorite|
          favorites[favorite.article_id] = true
        end
      end

      json({
        articles: articles.map do |a|
          Decorators::Article.new(a, favorited: favorites[a.id])
        end,
        articlesCount: articles.size,
      })
    end
  end
end
