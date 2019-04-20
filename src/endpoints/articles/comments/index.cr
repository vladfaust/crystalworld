module Endpoints::Articles::Comments
  struct Index
    include Onyx::HTTP::Endpoint

    params do
      path do
        type slug : String
      end
    end

    errors do
      type ArticleNotFound(404)
    end

    def call
      article = Onyx::SQL.query(Article.where(slug: params.path.slug).select(:id)).first?
      raise ArticleNotFound.new unless article

      comments = Onyx::SQL.query(Comment
        .select(Comment, :id)
        .where(article: article)
        .join(author: true) do |q|
          q.select(:username)
        end
      )

      view(Views::Comments.new(comments))
    end
  end
end
