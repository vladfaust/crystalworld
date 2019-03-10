module Views
  struct Comments
    include Onyx::HTTP::View

    def initialize(@comments : Array(::Comment))
    end

    json comments: @comments.map { |c| Comment.new(c, true) }
  end
end
