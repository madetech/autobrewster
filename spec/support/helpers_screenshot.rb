module AutoBrewster
  module Helpers
    module Screenshot
      class << self
        def populate_dir(dir, source_file = 'red.jpg', dest_file = 'red.jpg')
          AutoBrewster::Helpers.populate_dir(File.join('screens', dir.to_s), source_file, dest_file)
        end

        def get_dir_contents(dir)
          path = AutoBrewster::Helpers.test_dir_path(File.join('screens', dir.to_s))
          Dir.glob("#{path}/*.jpg")
        end
      end
    end
  end
end
