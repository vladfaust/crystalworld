module Endpoints::Articles
  struct Create
    include Onyx::HTTP::Endpoint
    include Auth
    include Articles

    auth!

    params do
      json require: true do
        type article do
          type title : String
          type description : String?
          type body : String
          type tag_list : Array(String), key: "tagList"
        end
      end
    end

    errors do
      type SlugAlreadyExists(422), slug : String do
        super("Article already exists with slug #{slug}")
      end
    end

    def call
      slug = params.json.article.title.downcase.gsub(' ', '-').gsub(/[^\w-]/, "")

      if Onyx::SQL.query(Article.where(slug: slug).select(:id)).any?
        raise SlugAlreadyExists.new(slug)
      end

      tags = Array(Tag).new

      params.json.article.tag_list.each do |tag|
        existing_tag? = Onyx::SQL.query(Tag.where(content: tag).select(:id)).first?

        if existing_tag = existing_tag?
          next tags << existing_tag
        end

        cursor = Onyx::SQL.exec(Tag.new(content: tag).insert)
        tags << Tag.new(id: cursor.last_insert_id.to_i)
      end

      article = Article.new(
        author: auth.user,
        slug: slug,
        title: params.json.article.title,
        description: params.json.article.description,
        body: params.json.article.body,
        tags: tags,
      )

      cursor = Onyx::SQL.exec(article.insert)

      article = Onyx::SQL.query(Article
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
