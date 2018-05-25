module Decorators
  struct Article
    def initialize(@article : ::Article, *, @favorited : Bool = false)
      raise ArgumentError.new("Article missing .author property") unless @article.author
    end

    def to_json(builder)
      builder.object do
        builder.field("title", @article.title)
        builder.field("slug", @article.slug)
        builder.field("body", @article.body)
        builder.field("createdAt", @article.created_at.to_s("%F"))
        builder.field("updatedAt", @article.updated_at.to_s("%F"))
        builder.field("description", @article.description)
        builder.field("tagList", @article.tags)
        builder.field("author", @article.author.not_nil!.username)
        builder.field("favorited", @favorited)
        builder.field("favoritesCount", @article.agg_favorites_count || 0)
      end
    end
  end
end
