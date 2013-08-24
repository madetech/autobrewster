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
