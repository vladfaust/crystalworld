module Views
  struct Tags
    include Onyx::REST::View

    def initialize(@tags : Array(::Tag))
    end

    json do
      object do
        field "tags" do
          array do
            @tags.each do |tag|
              string tag.content
            end
          end
        end
      end
    end
  end
end
