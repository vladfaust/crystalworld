module Actions::Articles
  def preload_articles_tags(articles : Enumerable(Article))
    tag_ids = articles.reduce(Set(Int32).new) do |set, article|
      set.concat(article.tags.map(&.id))
    end

    unless tag_ids.empty?
      tags = Onyx.query(Tag.where("rowid IN (#{tag_ids.join(", ")})").select(:id, :content))
      tags.each do |tag|
        articles.select { |a| a.tags.includes?(tag) }.each do |article|
          article.tags.find { |t| t == tag }.not_nil!.content = tag.content
        end
      end
    end
  end
end
