module Actions::Articles::Comments
  struct Index
    include Onyx::REST::Action

    params do
      path do
        type slug : String
      end
    end

    errors do
      type ArticleNotFound(404)
    end

    def call
      article = Onyx.query(Article.where(slug: params.path.slug).select(:id)).first?
      raise ArticleNotFound.new unless article

      comments = Onyx.query(Comment
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
