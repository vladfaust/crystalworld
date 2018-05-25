require "./authable"

module Authentication
  # This HTTP handler would extract Authentication token from the request headers and update its `#auth` property with `Authable` object.
  #
  # This `Authable` object will then be available to those Actions which include `Auth` module.
  class Handler
    def self.new
      Prism::ProcHandler.new do |handler, context|
        if token = context.request.headers["Authorization"]?.try &.[/Token ([\w.\.-]+)/, 1]?
          context.request.auth = Authentication::Authable.new(token)
        end
        handler.call_next(context)
      end
    end
  end
end
