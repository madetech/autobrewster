require 'spec_helper'

describe AutoBrewster::Screenshot do
  before(:each) do
    @server = AutoBrewster::Helpers::Server.default_test_server
    @screenshot = AutoBrewster::Screenshot.new(
      @server,
      File.expand_path("../test/",  __FILE__),
      {:home => '/'},
      [320]
    )

    @screenshot.clear_source_screens
    @screenshot.clear_compare_screens
    @screenshot.clear_diff_screens
  end

  describe '#capture' do
    it 'should capture screenshots of the specified paths at the specified widths' do
      @server.start
      @screenshot.capture(:source)
      @server.stop

      expect(AutoBrewster::Helpers::Screenshot.get_dir_contents(:source).length).to be 1
    end
  end

  describe '#compare_captured_screens' do
    before(:each) do
      AutoBrewster::Helpers::Screenshot.populate_dir(
        :source,
        source_file = 'red.jpg',
        dest_file = 'home-320.jpg'
      )
    end

    it 'should exit with a status of 1 if any of the captured screenshots differ' do
      AutoBrewster::Helpers::Screenshot.populate_dir(
        :compare,
        source_file = 'red_with_blue.jpg',
        dest_file = 'home-320.jpg'
      )

      expect{
        @screenshot.compare_captured_screens
      }.to raise_error(SystemExit)
    end

    it 'should exit with a status of 0 if the captured screenshots match' do
      AutoBrewster::Helpers::Screenshot.populate_dir(
        :compare,
        source_file = 'red.jpg',
        dest_file = 'home-320.jpg'
      )

      expect{
        @screenshot.compare_captured_screens
      }.not_to raise_error
    end

    it 'should exit with a status of 1 as soon as a differing screenshot is found if failfast is enabled' do
      AutoBrewster::Helpers::Screenshot.populate_dir(
        :compare,
        source_file = 'red_with_blue.jpg',
        dest_file = 'home-320.jpg'
      )

      expect{
        @screenshot.compare_captured_screens(failfast: true)
      }.to raise_error(SystemExit)
      expect(@screenshot.failed_fast).to be_true
    end
  end

  describe '#check_source_compare_screens_exist' do
    it 'should raise an error if the source or compare screens don\'t exist' do
      expect{
        @screenshot.check_source_compare_screens_exist('home', 320)
      }.to raise_error
    end

    it 'should not raise an error if the source and compare screens exist' do
      [:source, :compare].each do |dir|
        AutoBrewster::Helpers::Screenshot.populate_dir(
          dir,
          source_file = 'red.jpg',
          dest_file = 'home-320.jpg'
        )
      end

      expect{
        @screenshot.check_source_compare_screens_exist('home', 320)
      }.to_not raise_error
    end
  end

  describe '#clear_source_screens' do
    it 'should empty the source screenshot directory' do
      AutoBrewster::Helpers::Screenshot.populate_dir(:source)
      @screenshot.clear_source_screens
      expect(AutoBrewster::Helpers::Screenshot.get_dir_contents(:source).length).to be 0
    end
  end

  describe '#clear_compare_screens' do
    it 'should empty the compare screenshot directory' do
      AutoBrewster::Helpers::Screenshot.populate_dir(:compare)
      @screenshot.clear_compare_screens
      expect(AutoBrewster::Helpers::Screenshot.get_dir_contents(:compare).length).to be 0
    end
  end

  describe '#clear_diff_screens' do
    it 'should empty the diff screenshot directory' do
      AutoBrewster::Helpers::Screenshot.populate_dir(:diff)
      @screenshot.clear_diff_screens
      expect(AutoBrewster::Helpers::Screenshot.get_dir_contents(:diff).length).to be 0
    end
  end
end
