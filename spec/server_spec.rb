require 'net/http'
require 'spec_helper'

describe AutoBrewster::Server do
  describe '#start' do
    it 'should start a rack server on the specified port' do
      server = AutoBrewster::Helpers::Server.default_test_server
      server.start

      res = Net::HTTP.start('127.0.0.1', server.port) { |http| http.get('/') }
      expect(res.is_a?(Net::HTTPSuccess)).to be_true
      server.stop
    end

    it 'should load the post launch test files' do
      AutoBrewster.configure do |config|
        config.path = AutoBrewster::Helpers.spec_path('test')
      end

      AutoBrewster.include_support_post_launch
      expect(AutoBrewster::Test::Env.override_value).to eq 'set_in_post_launch'
    end

    it 'should timeout after the specified time' do
      server = AutoBrewster::Server.new(
        AutoBrewster::Helpers::Server.server_runner,
        5001,
        0.5,
        AutoBrewster::Helpers.spec_path('app/config.ru')
      )
      server.stub(:responsive?).and_return(false)

      expect{
        server.start
      }.to raise_error(Timeout::Error)

      RSpec.reset
      server.stop
    end
  end

  describe '#stop' do
    it 'should stop the running server' do
      server = AutoBrewster::Helpers::Server.default_test_server
      server.start
      server.stop

      expect{
          res = Net::HTTP.start('127.0.0.1', server.port) { |http| http.get('/') }
      }.to raise_error(Errno::ECONNREFUSED)
    end
  end

  describe '#get_host_with_protocol_and_port' do
    it 'should return the hostname if provided' do
      server = AutoBrewster::Server.new(
        AutoBrewster::Helpers::Server.server_runner,
        5001,
        10,
        AutoBrewster::Helpers.spec_path('app/config.ru'),
        'http://www.example.org/'
      )
      expect(server.get_host_with_protocol_and_port).to eq 'http://www.example.org/'
    end

    it 'should return the default hostname if none is provided' do
      server = AutoBrewster::Helpers::Server.default_test_server
      server.start
      expect(server.get_host_with_protocol_and_port).to eq "http://127.0.0.1:#{server.port}"
      server.stop
    end
  end
end
