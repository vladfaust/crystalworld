require "../../../decorators/comment"

module Actions::Articles::Comments
  struct Index < Prism::Action
    include Params

    params do
      param :slug, String
    end

    def call
      article = repo.query(Article
        .where(slug: params[:slug])
      ).first?
      halt!(404, "Article not found") unless article

      comments = repo.query(Comment
        .where(article: article)
        .join(:author, select: [:username])
      )

      json({
        comments: comments.map do |c|
          Decorators::Comment.new(c)
        end,
      })
    end
  end
end
