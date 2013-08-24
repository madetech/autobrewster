require 'rack'
require File.expand_path('../middleware',  __FILE__)

module AutoBrewster
  class Server
    attr_accessor :port,
                  :server,
                  :rackup_path,
                  :hostname,
                  :app

    def initialize(server, port, rackup_path = 'config.ru', hostname = false)
      ENV['RACK_ENV'] ||= 'test'

      @port = port
      @server = server
      @rackup_path = rackup_path
      @hostname = hostname
      @app = build_rack_app

      @middleware = AutoBrewster::Middleware.new(@app)
    end

    def start
      @server_thread = Thread.new do
        @server.call(@middleware, @port)
      end

      Timeout.timeout(10) { @server_thread.join(0.1) until responsive? }
    end

    def stop
      return if @server_thread.nil?
      @server_thread.kill
      Timeout.timeout(10) { @server_thread.join(0.1) until !responsive? }
    end

    def get_host_with_protocol_and_port
      if @hostname
        return @hostname
      else
        return "http://127.0.0.1:#{@port}"
      end
    end

    private
    def responsive?
      return false if @server_thread and @server_thread.join(0)

      res = Net::HTTP.start('127.0.0.1', @port) { |http| http.get('/__identify__') }

      if res.is_a?(Net::HTTPSuccess) or res.is_a?(Net::HTTPRedirection)
        return res.body == @app.object_id.to_s
      end
    rescue SystemCallError
      return false
    end

    def build_rack_app
      rackup_path = @rackup_path

      Rack::Builder.new do
        map '/' do
          run Rack::Builder.parse_file(rackup_path)[0]
        end
      end.to_app
    end
  end
end
