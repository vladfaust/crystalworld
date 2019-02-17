module Actions::Articles
  struct Feed
    include Onyx::REST::Action
    include Auth
    include Articles

    auth!

    params do
      query do
        type limit : Int32? = 20
        type offset : Int32?
      end
    end

    def call
      articles = Onyx.query(Article
        .select(Article, :id)
        .limit(params.query.limit)
        .offset(params.query.offset)

        .join(author: true) do |q|
          q.select(:username)
          q.join(followers: true) do |q|
            q.where(follower: auth.user)
          end
        end
      )

      preload_articles_tags(articles)

      favorites = {} of Int32 => Bool

      if articles.size > 0
        Onyx.query(Favorite
          .select(:article, :id)
          .where(user: auth.user)
          .and("article_id IN (?)", articles.map(&.id).join(','))
        ).each do |favorite|
          favorites[favorite.article.id] = true
        end
      end

      view(Views::Articles.new(articles, favorites))
    end
  end
end
