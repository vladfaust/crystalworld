module Endpoints::Articles::Comments
  struct Create
    include Onyx::HTTP::Endpoint
    include Auth

    auth!

    params do
      path do
        type slug : String
      end

      json require: true do
        type comment do
          type body : String
        end
      end
    end

    errors do
      type ArticleNotFound(404)
    end

    def call
      article = Onyx::SQL.query(Article.one.where(slug: params.path.slug).select(:id)).first?
      raise ArticleNotFound.new unless article

      comment = Comment.new(
        article: article,
        author: auth.user,
        body: params.json.comment.body
      )

      cursor = Onyx::SQL.exec(comment.insert)

      comment = Onyx::SQL.query(Comment
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
