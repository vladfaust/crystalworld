ENV["APP_ENV"] ||= "development"

# This is a macro, which is a part of Crystal's meta programming
# Macros are executed while compilation
{% begin %}
  # This code will be compiled only if APP_ENV equals to "production"
  {% if env("APP_ENV") != "production" %}
    require "dotenv"
    Dotenv.load ".env.#{ENV["APP_ENV"]}" # Load environment specific variables, e.g. from .env.development
  {% end %}
{% end %}
