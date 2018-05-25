require "pg"
require "migrate"
require "./src/env"
require "./src/services/logger"

Services::Logger.init(Logger::DEBUG)

desc "Migrate database to the latest version"
task :dbmigrate do
  migrator = Migrate::Migrator.new(
    DB.open(ENV["DATABASE_URL"]),
    logger
  )
  migrator.to_latest
end
