module Actions::Articles
  struct Update
    include Onyx::REST::Action
    include Auth
    include Articles

    auth!

    params do
      path do
        type slug : String
      end

      json do
        type article do
          type description : String?
          type body : String?
          type tags : Array(String)?
        end
      end
    end

    errors do
      type JSONRequestExpected(400)

      type NoParametersToUpdate(400) do
        super("At least one parameter to update is required")
      end

      type ArticleNotFound(404)
      type NoChangesToUpdate(422)
    end

    def call
      raise JSONRequestExpected.new unless json = params.json

      if {{ %w(description body tags).map { |a| "json.article.#{a.id}.nil?" }.join(" && ").id }}
        raise NoParametersToUpdate.new
      end

      article = Onyx.query(Article
        .select(Article, :id)
        .where(slug: params.path.slug)
        .join(author: true) do |q|
          q.select(:id, :username)
        end
      ).first?

      raise ArticleNotFound.new unless article
      raise Unauthorized.new unless article.author == auth.user

      changeset = article.changeset

      {% begin %}
        {% for attr in %w(description body) %}
          if param = json.article.{{attr.id}}
            changeset.update({{attr.id}}: param)
          end
        {% end %}
      {% end %}

      if param_tags = json.article.tags
        tags = Array(Tag).new

        param_tags.each do |tag|
          existing_tag? = Onyx.query(Tag.where(content: tag).select(:id)).first?

          if existing_tag = existing_tag?
            next tags << existing_tag
          end

          cursor = Onyx.exec(Tag.new(content: tag).insert)
          tags << Tag.new(id: cursor.last_insert_id.to_i)
        end

        unless changeset.values["tags"].as(Array(Tag)).map(&.id) == tags.map(&.id)
          changeset.update(tags: tags)
        end
      end

      raise NoChangesToUpdate.new if changeset.empty?

      changeset.update(updated_at: Time.now)

      # TODO: Make it async
      #

      Onyx.exec(article.update(changeset))
      preload_articles_tags({article})

      favorited = false
      favorited = Onyx.query(Favorite
        .select(:id)
        .where(article: article, user: auth.user)
      ).any? if auth.authed?

      status(204)
      view(Views::Article.new(article, favorited: favorited))
    end
  end
end
