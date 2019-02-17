module Actions::Articles
  struct Get
    include Onyx::REST::Action
    include Auth
    include Articles

    params do
      path do
        type slug : String
      end
    end

    errors do
      type ArticleNotFound(404)
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

      preload_articles_tags({article})

      favorited = false
      favorited = Onyx.query(Favorite
        .one
        .select(:id)
        .where(article: article, user: auth.user)
      ).any? if auth?.try &.authed?

      view(Views::Article.new(article, favorited: favorited))
    end
  end
end
