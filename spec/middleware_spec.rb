require 'spec_helper'

describe AutoBrewster::Middleware do
  describe '#call' do
    before(:each) do
      @app = Proc.new {|env| [200, {}, ['Hello, World!']] }
      @middleware = AutoBrewster::Middleware.new(@app)
    end

    it 'should return the app ID if the __identify__ URL is passed' do
      response = @middleware.call('PATH_INFO' => '/__identify__')
      expect(response[2][0]).to eq @app.object_id.to_s
    end

    it 'should proxy any other request to the app' do
      response = @middleware.call('PATH_INFO' => '/test')
      expect(response[2][0]).to eq 'Hello, World!'
    end
  end
end
