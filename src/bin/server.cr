require "prism"

require "../env"
require "../services/logger"
require "../services/repo"
require "../app/authentication/handler"
require "../app/router"

# Initialize applicaiton services
Services::Logger.init(ENV["APP_ENV"] == "production" ? Logger::INFO : Logger::DEBUG)
Services::Repository.init(ENV["DATABASE_URL"], logger)

# Create handlers which will process an HTTP request sequentially
log_handler = Prism::LogHandler.new(logger)       # Logs requests
auth_handler = Authentication::Handler.new        # Handles JWT authentication
cacher = Prism::Router::SimpleCacher.new(100_000) # Caches routing, increasing its performance
router = Router.new(cacher)

handlers = [log_handler, auth_handler, router] # Let's just put them all in one array

host = ENV["HOST"]? || "0.0.0.0"       # Get HOST environment variable or use "0.0.0.0" by default
port = ENV["PORT"]?.try &.to_i || 5000 # ditto

server = Prism::Server.new(host, port, handlers, logger)

logger.info("Welcome to the Crystal World! ✨ https://github.com/vladfaust/crystalworld")
server.listen(true) # *true* argument enables multi-process usage of a same port
