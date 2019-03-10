require "onyx/env"
require "onyx/http"

require "sqlite3"
require "onyx/sql"

require "../models"
require "../views"
require "../endpoints"

Onyx.draw do
  get "/" { } # Just a 200 response

  post "/users", Endpoints::Users::Create
  put "/user", Endpoints::Users::Update
  post "/users/login", Endpoints::Users::Login
  get "/user", Endpoints::Users::Get

  post "/articles", Endpoints::Articles::Create
  put "/articles/:slug", Endpoints::Articles::Update
  delete "/articles/:slug", Endpoints::Articles::Delete
  get "/articles/feed", Endpoints::Articles::Feed
  get "/articles", Endpoints::Articles::Index
  get "/articles/:slug", Endpoints::Articles::Get

  post "/articles/:slug/favorite", Endpoints::Articles::Favorites::Create
  delete "/articles/:slug/favorite", Endpoints::Articles::Favorites::Delete

  post "/articles/:slug/comments", Endpoints::Articles::Comments::Create
  delete "/articles/:slug/comments/:id", Endpoints::Articles::Comments::Delete
  get "/articles/:slug/comments", Endpoints::Articles::Comments::Index

  get "/profiles/:username", Endpoints::Profiles::Get
  post "/profiles/:username/follow", Endpoints::Profiles::Follows::Create
  delete "/profiles/:username/follow", Endpoints::Profiles::Follows::Delete

  get "/tags", Endpoints::Tags::Index
end

Onyx.logger.info("Welcome to the " + "Crystal World!".colorize.mode(:bold).to_s + " © Vlad Faust <mail@vladfaust.com>")
Onyx.logger.info("For updates visit " + "https://github.com/vladfaust/crystalworld".colorize(:light_gray).to_s)

Onyx.listen(
  host: ENV["HOST"]? || "0.0.0.0",
  port: ENV["PORT"]?.try(&.to_i) || 5000
)
