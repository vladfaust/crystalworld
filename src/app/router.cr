require "prism/router"
require "./actions/**"

# See http://github.vladfaust.com/prism/Prism/Router.html.
class Router
  def self.new(cacher)
    Prism::Router.new(cacher) do
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
  end
end
