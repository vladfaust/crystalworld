module Views
  struct Article
    include Onyx::REST::View

    def initialize(@article : ::Article, @favorited : Bool = false, @nested = false)
    end

    json do
      object do
        unless @nested
          string "article"
          start_object
        end

        field "title", @article.title
        field "slug", @article.slug
        field "body", @article.body
        field "createdAt", @article.created_at.to_s(TIME_FORMAT)
        field "updatedAt", @article.updated_at.try &.to_s(TIME_FORMAT)
        field "description", @article.description
        field "tagList", @article.tags.map(&.content)
        field "author", @article.author.username
        field "favorited", @favorited
        field "favoritesCount", @article.agg_favorites_count

        unless @nested
          end_object
        end
      end
    end
  end
end
