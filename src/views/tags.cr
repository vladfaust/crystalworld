module Views
  struct Tags
    include Onyx::HTTP::View

    def initialize(@tags : Array(::Tag))
    end

    json tags: @tags.map(&.content)
  end
end
