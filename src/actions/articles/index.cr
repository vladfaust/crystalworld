module Actions::Articles
  struct Index
    include Onyx::REST::Action
    include Auth
    include Articles

    params do
      query do
        type author : String?
        type favorited : String?
        type tag : String?
        type limit : Int32? = 20
        type offset : Int32?
      end
    end

    def call
      articles = uninitialized Array(Article)

      if params.query.author
        articles = Onyx.query(Article
          .select(Article, :id)
          .limit(params.query.limit)
          .offset(params.query.offset)

          .join(author: true) do |q|
            q.select(:username)
            q.where(username: params.query.author)
          end
        )
      elsif params.query.tag
        articles = Onyx.query(Article
          .select(Article, :id)
          .limit(params.query.limit)
          .offset(params.query.offset)

          .join(tags: true, on: "") do |q|
            q.where(content: params.query.tag)
          end

          .join(author: true) do |q|
            q.select(:username)
          end
        )
      elsif params.query.favorited
        articles = Onyx.query(Article
          .select(Article, :id)
          .limit(params.query.limit)
          .offset(params.query.offset)

          .join(author: true) do |q|
            q.select(:username)
          end

          .join(favorites: true) do |q|
            q.join(user: true) do |q|
              q.where(username: params.query.favorited)
            end
          end
        )
      else
        articles = Onyx.query(Article
          .select(Article, :id)
          .limit(params.query.limit)
          .offset(params.query.offset)

          .join(author: true) do |q|
            q.select(:username)
          end
        )
      end

      favorites = articles.reduce({} of Int32 => Bool) do |hash, article|
        hash[article.id] = false; hash
      end

      preload_articles_tags(articles)

      if auth?.try &.authed?
        user_favorites = Onyx.query(Favorite
          .select(:article)
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
