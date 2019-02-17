module Actions::Articles::Comments
  struct Create
    include Onyx::REST::Action
    include Auth

    auth!

    params do
      path do
        type slug : String
      end

      json do
        type comment do
          type body : String
        end
      end
    end

    errors do
      type JSONRequestExpected(400)
      type ArticleNotFound(404)
    end

    def call
      raise JSONRequestExpected.new unless json = params.json

      article = Onyx.query(Article.one.where(slug: params.path.slug).select(:id)).first?
      raise ArticleNotFound.new unless article

      comment = Comment.new(
        article: article,
        author: auth.user,
        body: json.comment.body
      )

      cursor = Onyx.exec(comment.insert)

      comment = Onyx.query(Comment
        .where(id: cursor.last_insert_id.to_i)
        .select(Comment, :id)
        .join(author: true) do |q|
          q.select(:username)
        end
      ).first

      status(201)
      view(Views::Comment.new(comment))
    end
  end
end
