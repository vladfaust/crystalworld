module Actions::Articles::Comments
  struct Delete
    include Onyx::REST::Action
    include Auth

    auth!

    params do
      path do
        type slug : String
        type id : Int32
      end
    end

    errors do
      type CommentNotFound(404)
      type CommentDoesNotBelongToThisArticle(400)
    end

    def call
      comment = Onyx.query(Comment
        .select(:id, :author)
        .where(id: params.path.id)
        .join(article: true) do |q|
          q.select(:slug)
        end
      ).first?

      raise CommentNotFound.new unless comment
      raise Forbidden.new unless auth.user == comment.author
      raise CommentDoesNotBelongToThisArticle.new unless comment.article.slug == params.path.slug

      Onyx.exec(comment.delete)
      status(202)
    end
  end
end
