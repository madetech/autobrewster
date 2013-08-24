require 'spec_helper'

describe AutoBrewster::CLI do
  describe '#get_action' do
    it 'should return :compare_screens if not argument is passed' do
      cli = AutoBrewster::CLI.new([])
      expect(cli.get_action).to be :compare_screens
    end

    it 'should raise an error if an invalid method is called' do
      lambda {
        cli = AutoBrewster::CLI.new(:does_not_exist).get_action
      }.should raise_error
    end

    it 'should return the method name if a valid method is passed' do
      cli = AutoBrewster::CLI.new([:generate_source_screens])
      expect(cli.get_action).to be :generate_source_screens
    end
  end
end
