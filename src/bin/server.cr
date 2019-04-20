require "onyx/env"
require "onyx/http"

require "sqlite3"
require "onyx/sql"

require "../models"
require "../views"
require "../endpoints"

Onyx::HTTP.on do |r|
  r.get "/" { } # Just a 200 response

  r.on "/user" do
    r.put "/", Endpoints::Users::Update
    r.get "/", Endpoints::Users::Get
  end

  r.on "/users" do
    r.post "/", Endpoints::Users::Create
    r.post "/login", Endpoints::Users::Login
  end

  r.on "/articles" do
    r.post "/", Endpoints::Articles::Create
    r.get "/", Endpoints::Articles::Index
    r.get "/feed", Endpoints::Articles::Feed

    r.on "/:slug" do
      r.put "/", Endpoints::Articles::Update
      r.delete "/", Endpoints::Articles::Delete
      r.get "/", Endpoints::Articles::Get

      r.on "/favorite" do
        r.post "/", Endpoints::Articles::Favorites::Create
        r.delete "/", Endpoints::Articles::Favorites::Delete
      end

      r.on "/comments" do
        r.post "/", Endpoints::Articles::Comments::Create
        r.delete "/:id", Endpoints::Articles::Comments::Delete
        r.get "/", Endpoints::Articles::Comments::Index
      end
    end
  end

  r.on "/profiles/:username" do
    r.get "/", Endpoints::Profiles::Get

    r.on "/follow" do
      r.post "/", Endpoints::Profiles::Follows::Create
      r.delete "/", Endpoints::Profiles::Follows::Delete
    end
  end

  r.get "/tags", Endpoints::Tags::Index
end

Onyx.logger.info("Welcome to the " + "Crystal World!".colorize.mode(:bold).to_s + " © Vlad Faust <mail@vladfaust.com>")
Onyx.logger.info("For updates visit " + "https://github.com/vladfaust/crystalworld".colorize(:light_gray).to_s)

Onyx::HTTP.listen(
  host: ENV["HOST"]? || "0.0.0.0",
  port: ENV["PORT"]?.try(&.to_i) || 5000
)
