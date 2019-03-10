module Endpoints::Tags
  struct Index
    include Onyx::HTTP::Endpoint

    def call
      tags = Onyx.query(Tag.all.select(:content))
      view(Views::Tags.new(tags))
    end
  end
end
