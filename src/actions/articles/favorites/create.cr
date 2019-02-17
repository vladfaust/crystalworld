module Actions::Articles::Favorites
  struct Create
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
      type AlreadyInFavorites(422)
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

      begin
        Onyx.exec(Favorite.insert(article: article, user: auth.user))
      rescue ex : SQLite3::Exception
        case ex.message
        when /UNIQUE constraint failed/
          raise AlreadyInFavorites.new
        else
          raise ex
        end
      end

      changeset = article.changeset
      changeset.update(agg_favorites_count: article.agg_favorites_count + 1)
      article.apply(changeset)

      # TODO: Make it async
      Onyx.exec(article.update(changeset))
      preload_articles_tags({article})

      status(201)
      view(Views::Article.new(article, favorited: true))
    end
  end
end
