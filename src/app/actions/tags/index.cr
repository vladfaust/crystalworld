module Actions::Tags
  struct Index < Prism::Action
    def call
      tags = [] of String

      repo.query("SELECT DISTINCT UNNEST(tags) AS tags FROM articles").try do |rs|
        rs.each do
          tags << rs.read(String)
        end
      end

      json({
        tags: tags,
      })
    end
  end
end
