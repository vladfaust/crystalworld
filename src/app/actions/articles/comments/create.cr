require "../../../decorators/comment"

module Actions::Articles::Comments
  struct Create < Prism::Action
    include Auth
    include Params

    auth!

    params do
      param :slug, String
      param :comment do
        param :body, String
      end
    end

    def call
      article = repo.query(Article.where(slug: params[:slug])).first?
      halt!(404, "Article not found") unless article

      comment = Comment.new(article: article, author: auth.user, body: params[:comment][:body])
      halt!(400, "Invalid comment: #{comment.errors}") unless comment.valid?

      repo.insert(comment)
      comment = repo.query(Comment
        .last
        .join(:author, select: [:username])
      ).first

      json(201, {
        comment: Decorators::Comment.new(comment),
      })
    end
  end
end
