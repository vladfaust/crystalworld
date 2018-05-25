module Actions::Articles
  struct Delete < Prism::Action
    include Params
    include Auth

    auth!

    params do
      param :slug, String
    end

    def call
      article = repo.query(Article.where(slug: params[:slug])).first?

      halt!(404, "Article not found") unless article
      halt!(403) unless article.author_id == auth.user.id

      repo.delete(article)
      status(202)
    end
  end
end
