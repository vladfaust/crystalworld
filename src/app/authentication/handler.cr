require "./authable"

module Authentication
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
