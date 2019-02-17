require "onyx/env"
require "onyx/rest"

require "sqlite3"
require "onyx/sql"

require "../models"
require "../views"
require "../actions"

Onyx.draw do
  get "/" { } # Just a 200 response

  post "/users", Actions::Users::Create
  put "/user", Actions::Users::Update
  post "/users/login", Actions::Users::Login
  get "/user", Actions::Users::Get

  post "/articles", Actions::Articles::Create
  put "/articles/:slug", Actions::Articles::Update
  delete "/articles/:slug", Actions::Articles::Delete
  get "/articles/feed", Actions::Articles::Feed
  get "/articles", Actions::Articles::Index
  get "/articles/:slug", Actions::Articles::Get

  post "/articles/:slug/favorite", Actions::Articles::Favorites::Create
  delete "/articles/:slug/favorite", Actions::Articles::Favorites::Delete

  post "/articles/:slug/comments", Actions::Articles::Comments::Create
  delete "/articles/:slug/comments/:id", Actions::Articles::Comments::Delete
  get "/articles/:slug/comments", Actions::Articles::Comments::Index

  get "/profiles/:username", Actions::Profiles::Get
  post "/profiles/:username/follow", Actions::Profiles::Follows::Create
  delete "/profiles/:username/follow", Actions::Profiles::Follows::Delete

  get "/tags", Actions::Tags::Index
end

Onyx.logger.info("Welcome to the " + "Crystal World!".colorize.mode(:bold).to_s + " © Vlad Faust <mail@vladfaust.com>")
Onyx.logger.info("For updates visit " + "https://github.com/vladfaust/crystalworld".colorize(:light_gray).to_s)

Onyx.render(:json)
Onyx.listen
