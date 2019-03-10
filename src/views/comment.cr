module Views
  struct Comment
    include Onyx::HTTP::View

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
        field "createdAt", @comment.created_at.try &.to_s(TIME_FORMAT)
        field "updatedAt", @comment.updated_at.try &.to_s(TIME_FORMAT)
        field "author", @comment.author.try &.username

        unless @nested
          end_object
        end
      end
    end
  end
end
