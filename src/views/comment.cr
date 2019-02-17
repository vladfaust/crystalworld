module Views
  struct Comment
    include Onyx::REST::View

    def initialize(@comment : ::Comment, @nested = false)
    end

    json do
      object do
        unless @nested
          string "comment"
          start_object
        end

        field "id", @comment.id
        field "body", @comment.body
        field "createdAt", @comment.created_at.to_s(TIME_FORMAT)
        field "updatedAt", @comment.updated_at.try &.to_s(TIME_FORMAT)
        field "author", @comment.author.username

        unless @nested
          end_object
        end
      end
    end
  end
end
