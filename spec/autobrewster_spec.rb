require 'spec_helper'

describe AutoBrewster do
  before(:each) do
    AutoBrewster.configure do |config|
      config.rackup_path = AutoBrewster::Helpers.spec_path('app/config.ru')
      config.path = AutoBrewster::Helpers.spec_path('test')
    end
  end

  describe '#setup' do
    it 'should load the env file' do
      AutoBrewster.setup
      expect(AutoBrewster::Test::Env.test_value).to eq 'set_in_env'
    end

    it 'should load subsequent test files after the env file' do
      AutoBrewster.setup
      expect(AutoBrewster::Test::Env.override_value).to eq 'set_in_secondary'
    end
  end

  describe '#configure' do
    it 'should be configured to start a server by default' do
      expect(AutoBrewster.server_start).to be_true
    end

    it 'should be configured to start a server on port 5001 by default' do
      expect(AutoBrewster.server_port).to be 5001
    end

    it 'should be configured to not set a hostname by default' do
      expect(AutoBrewster.hostname).to be_false
    end

    it 'should be set to capture at 320 and 1024 widths by default' do
      expect(AutoBrewster.screen_widths).to eq [320, 1024]
    end

    it 'should be set to capture the root URL by default' do
      expect(AutoBrewster.url_paths).to eq({:home => '/'})
    end

    it 'should allow the server option to accept a block' do
      start_server_state = AutoBrewster.server
      AutoBrewster.configure do |config|
        config.server { 'Test' }
      end

      expect(AutoBrewster.server.call).to eq 'Test'
      AutoBrewster.server = start_server_state
    end
  end
end
