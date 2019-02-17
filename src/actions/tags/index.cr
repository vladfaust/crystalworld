module Actions::Tags
  struct Index
    include Onyx::REST::Action

    def call
      tags = Onyx.query(Tag.all.select(:content))
      view(Views::Tags.new(tags))
    end
  end
end
