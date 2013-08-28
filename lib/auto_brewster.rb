require File.expand_path('../auto_brewster/server',  __FILE__)
require File.expand_path('../auto_brewster/screenshot',  __FILE__)
require File.expand_path('../auto_brewster/cli',  __FILE__)

module AutoBrewster
  class << self
    attr_accessor :server, :server_start, :server_port, :rackup_path, :hostname, :server_timeout
    attr_accessor :screen_widths, :url_paths
    attr_accessor :path
    attr_accessor :debug, :failfast

    def configure
      yield self
    end

    def setup
      include_support_env
      include_support_pre_launch
      @server = AutoBrewster::Server.new(server, server_port, server_timeout, rackup_path, hostname)
      @screenshot = AutoBrewster::Screenshot.new(@server, path, url_paths, screen_widths)
    end

    def compare_screens
      setup
      @screenshot.clear_compare_screens
      start_test_server
      @screenshot.capture(:compare)
      @screenshot.compare_captured_screens
    end

    def clear_source_screens
      setup
      @screenshot.clear_source_screens
    end

    def start_test_server
      return unless AutoBrewster.server_start
      @server.start
    end

    def generate_source_screens
      setup
      start_test_server
      @screenshot.capture(:source)
    end

    def server(&block)
      if block_given?
        @server = block
      else
        @server
      end
    end

    def run_default_server(app, port)
      require 'rack/handler/thin'
      Thin::Logging.silent = true unless debug
      Rack::Handler::Thin.run(app, :Port => port, :AccessLog => [])
    end

    def include_support_post_launch
      Dir.glob("#{path}/support/post_launch/*.rb").map { |file| require file }
    end

    private
    def include_support_pre_launch
      Dir.glob("#{path}/support/pre_launch/*.rb").map { |file| require file }
    end

    def include_support_env
      env_path = "#{path}/support/env.rb"
      require env_path if File.exists?(env_path)
    end
  end
end

AutoBrewster.configure do |config|
  config.server_start = true
  config.server_port = 5001
  config.path = "#{Dir.pwd}/test/autobrewster"
  config.rackup_path = 'config.ru'
  config.server {|app, port| AutoBrewster.run_default_server(app, port)}
  config.server_timeout = 10
  config.hostname = false
  config.debug = true
  config.failfast = false
  config.screen_widths = [320, 1024]
  config.url_paths = {
    :home => '/'
  }
end
