require "../../decorators/article"

module Actions::Articles
  struct Create < Prism::Action
    include Params
    include Auth

    auth!

    params do
      param :article do
        param :title, String
        param :description, String?
        param :body, String
        param :tagList, Array(String)
      end
    end

    def call
      slug = params[:article][:title].downcase.gsub(' ', '-').gsub(/[^\w-]/, "")

      if repo.query(Article.where(slug: slug)).any?
        halt!(422, "Article already exists with this slug")
      end

      article = Article.new(
        author: auth.user,
        slug: slug,
        title: params[:article][:title],
        description: params[:article][:description],
        body: params[:article][:body],
        tags: params[:article][:tagList],
      )

      halt!(400, "Invalid article: #{article.errors}") unless article.valid?
      article = repo.insert(article)
      article.author = repo.query(User.select(:username).where(id: auth.user.id)).first

      json(201, {
        article: Decorators::Article.new(article),
      })
    end
  end
end
