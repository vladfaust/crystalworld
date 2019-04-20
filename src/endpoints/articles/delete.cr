module Endpoints::Articles
  struct Delete
    include Onyx::HTTP::Endpoint
    include Auth

    auth!

    params do
      path do
        type slug : String
      end
    end

    errors do
      type ArticleNotFound(404)
    end

    def call
      article = Onyx::SQL.query(Article.where(slug: params.path.slug).select(:author, :id)).first?

      raise ArticleNotFound.new unless article
      raise Forbidden.new unless article.author == auth.user

      Onyx::SQL.exec(article.delete)
      status(202)
    end
  end
end
