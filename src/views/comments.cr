module Views
  struct Comments
    include Onyx::REST::View

    def initialize(@comments : Array(::Comment))
    end

    json do
      object do
        field "comments" do
          array do
            @comments.each do |comment|
              Comment.new(comment, true).to_json(itself)
            end
          end
        end
      end
    end
  end
end
