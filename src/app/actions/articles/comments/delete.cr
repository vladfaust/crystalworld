module Actions::Articles::Comments
  struct Delete < Prism::Action
    include Auth
    include Params

    auth!

    params do
      param :slug, String
      param :id, Int64
    end

    def call
      comment = repo.query(Comment
        .where(id: params[:id])
        .join(:article, select: [:slug])
      ).first?

      halt!(404, "Comment not found with this id") unless comment
      halt!(403) unless auth.user.id == comment.author_id
      halt!(400, "Comment doesn't belong to this article") unless comment.article.not_nil!.slug == params[:slug]

      repo.delete(comment)
      status(202)
    end
  end
end
