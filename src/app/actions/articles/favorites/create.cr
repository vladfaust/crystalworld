require "../../../decorators/article"

module Actions::Articles::Favorites
  struct Create < Prism::Action
    include Params
    include Auth

    auth!

    params do
      param :slug, String
    end

    def call
      article = repo.query(Article.where(slug: params[:slug]).join(:author, select: [:username])).first?
      halt!(404, "Article not found") unless article

      favorite = Favorite.new(article: article, user: auth.user)

      begin
        repo.insert(favorite.valid!)
      rescue ex : PQ::PQError
        case ex.message
        when /duplicate key/ then halt!(422, "Already in favorites")
        else
          raise ex
        end
      end

      article.agg_favorites_count += 1
      repo.update(article.valid!)

      json(201, {
        article: Decorators::Article.new(article, favorited: true),
      })
    end
  end
end
