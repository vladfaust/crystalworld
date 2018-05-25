ENV["APP_ENV"] ||= "development"

{% begin %}
  {% if env("APP_ENV") != "production" %}
    require "dotenv"
    Dotenv.load ".env.#{ENV["APP_ENV"]}" # Specific environment variables, e.g. .env.development
  {% end %}
{% end %}
