module Actions::Articles
  struct Create
    include Onyx::REST::Action
    include Auth
    include Articles

    auth!

    params do
      json do
        type article do
          type title : String
          type description : String?
          type body : String
          type tag_list : Array(String), key: "tagList"
        end
      end
    end

    errors do
      type JSONRequestExpected(400)

      type SlugAlreadyExists(422), slug : String do
        super("Article already exists with slug #{slug}")
      end
    end

    def call
      raise JSONRequestExpected.new unless json = params.json

      slug = json.article.title.downcase.gsub(' ', '-').gsub(/[^\w-]/, "")

      if Onyx.query(Article.where(slug: slug).select(:id)).any?
        raise SlugAlreadyExists.new(slug)
      end

      tags = Array(Tag).new

      json.article.tag_list.each do |tag|
        existing_tag? = Onyx.query(Tag.where(content: tag).select(:id)).first?

        if existing_tag = existing_tag?
          next tags << existing_tag
        end

        cursor = Onyx.exec(Tag.new(content: tag).insert)
        tags << Tag.new(id: cursor.last_insert_id.to_i)
      end

      article = Article.new(
        author: auth.user,
        slug: slug,
        title: json.article.title,
        description: json.article.description,
        body: json.article.body,
        tags: tags,
      )

      cursor = Onyx.exec(article.insert)

      article = Onyx.query(Article
        .where(id: cursor.last_insert_id.to_i)
        .select(Article, :id)
        .join(author: true) do |q|
          q.select(:username)
        end
      ).first

      preload_articles_tags({article})

      status(201)
      view(Views::Article.new(article))
    end
  end
end
