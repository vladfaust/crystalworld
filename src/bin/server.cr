require "prism"
require "../env"
require "../services/logger"
require "../services/repo"
require "../app/authentication/handler"
require "../app/router"

Services::Logger.init(Logger::DEBUG)
Services::Repository.init(ENV["DATABASE_URL"], logger)

log_handler = Prism::LogHandler.new(logger)
auth_handler = Authentication::Handler.new

cacher = Prism::Router::SimpleCacher.new(100_000)
router = Router.new(cacher)

host = ENV["HOST"]? || "0.0.0.0"
port = ENV["PORT"]?.try &.to_i || 5000

server = Prism::Server.new(host, port, [log_handler, auth_handler, router], logger)

logger.debug("Welcome to Crystal World! ✨ https://github.com/vladfaust/crystalworld")
server.listen(true)
