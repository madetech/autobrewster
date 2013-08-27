module AutoBrewster
  module Helpers
    module Server
      class << self
        def default_test_server
          AutoBrewster::Server.new(
            server_runner,
            5001,
            10,
            AutoBrewster::Helpers.spec_path('app/config.ru')
          )
        end

        def server_runner
          Proc.new { |app, port|
            require 'rack/handler/thin'
            Thin::Logging.silent = true
            Rack::Handler::Thin.run(app, :Port => port, :AccessLog => [])
          }
        end
      end
    end
  end
end
