module Decorators
  struct Comment
    def initialize(@comment : ::Comment)
      raise ArgumentError.new("Comment missing .author property") unless @comment.author
    end

    def to_json(builder)
      builder.object do
        builder.field("id", @comment.id)
        builder.field("body", @comment.body)
        builder.field("createdAt", @comment.created_at.to_s("%F"))
        builder.field("updatedAt", @comment.updated_at.to_s("%F"))
        builder.field("author", @comment.author.not_nil!.username)
      end
    end
  end
end
