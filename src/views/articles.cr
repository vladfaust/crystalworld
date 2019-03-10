module Views
  struct Articles
    include Onyx::HTTP::View

    def initialize(@articles : Array(::Article), @favorites : Hash(Int32, Bool))
    end

    json({
      articles: @articles.map do |a|
        Article.new(a, !!@favorites[a.id]?, true)
      end,
      articlesCount: @articles.size,
    })
  end
end
