module Endpoints::Articles
  struct Get
    include Onyx::HTTP::Endpoint
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
      article = Onyx::SQL.query(Article
        .select(Article, :id)
        .where(slug: params.path.slug)
        .join(author: true) do |x|
          x.select(:username)
        end # .join(:author) do |x|
      #   x.select(:username)
      # end
      ).first?

      raise ArticleNotFound.new unless article

      preload_articles_tags({article})

      favorited = false
      favorited = Onyx::SQL.query(Favorite
        .one
        .select(:id)
        .where(article: article, user: auth.user)
      ).any? if auth?.try &.authed?

      view(Views::Article.new(article, favorited: favorited))
    end
  end
end
