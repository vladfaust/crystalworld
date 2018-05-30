require "../../decorators/article"

module Actions::Articles
  struct Index < Prism::Action
    include Params
    include Auth

    params do
      param :author, String?
      param :favorited, String?
      param :tag, String?
    end

    def call
      articles = uninitialized Array(Article)

      if params[:author]
        articles = repo.query(Article
          .where("author.username = ?", {params[:author]})
          .join(:author, select: [:username])
        )
      elsif params[:tag]
        articles = repo.query(Article
          .where("tags @> ARRAY[?]::text[]", {params[:tag]})
          .join(:author, select: [:username])
        )
      elsif params[:favorited]
        articles = repo.query(Article
          .join(:favorites, select: nil)
          .join(:author, select: [:username])
          .join(:users, on: {:id, "favorites.user_id"}, select: nil)
          .where("users.username = ?", {params[:favorited]})
        )
      else
        articles = repo.query(Article.all.join(:author, select: [:username]))
      end

      favorites = articles.reduce({} of Core::PrimaryKey => Bool) do |hash, article|
        hash[article.id] = false; hash
      end

      if auth?
        user_favorites = repo.query(Favorite
          .where(user: auth.user)
          .and("article_id = ANY(?)", {'{' + articles.map(&.id).join(',') + '}'})
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
