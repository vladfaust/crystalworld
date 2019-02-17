module Views
  struct Articles
    include Onyx::REST::View

    def initialize(@articles : Array(::Article), @favorites : Hash(Int32, Bool))
    end

    json do
      object do
        field "articles" do
          array do
            @articles.each do |article|
              Article.new(article, !!@favorites[article.id]?, true).to_json(itself)
            end
          end
        end

        field "articlesCount", @articles.size
      end
    end
  end
end
