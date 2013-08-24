module AutoBrewster
  module Helpers
    class << self
      def spec_path(path)
        "#{File.expand_path('../../',  __FILE__)}/#{path}"
      end

      def populate_dir(dir, source_file, dest_file)
        FileUtils.mkdir_p(test_dir_path(dir))
        FileUtils.copy(
          File.join(fixture_dir_path, source_file),
          File.join(test_dir_path(dir), dest_file)
        )
      end

      def test_dir_path(dir = '')
        spec_path("test/#{dir}")
      end

      def fixture_dir_path
        spec_path("fixtures")
      end
    end
  end
end
