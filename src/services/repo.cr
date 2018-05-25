require "pg"
require "core"
require "core/logger/standard"

class Services::Repository
  class_getter! instance : Core::Repository?

  def self.init(database_url : String, logger : ::Logger)
    @@instance = Core::Repository.new(
      DB.open(database_url),
      Core::Logger::Standard.new(logger),
    )
  end
end

# A globally accessible repository instance.
def repo
  Services::Repository.instance
end
