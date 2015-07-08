module Rack
  # A heartbeat mechanism for the server. This will add a _/heartbeat_ endpoint
  # that returns status 200 and content OK when executed.
  #
  # @example
  #  use Rack::Heartbeat
  #
  class Heartbeat
    def initialize(app, opts = {})
      @app  = app
      @opts = opts
      @opts[:path] = (@opts[:path] || '/heartbeat').freeze
      response = (@opts[:response] || [200, { 'Content-Type' => 'text/plain' }, ['OK'.freeze].freeze]).freeze
      @opts[:response] = response
    end

    def call(env)
      if env['PATH_INFO'] == @opts[:path]
        NewRelic::Agent.ignore_transaction if defined?(NewRelic)
        @opts[:response]
      else
        @app.call(env)
      end
    end
  end
end
